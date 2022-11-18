#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <NTPClient.h>
#include <WiFiUdp.h>
#include <ArduinoJson.h>
// #include <ArduinoWebsockets.h>
#include <WebSocketsServer.h>
#include "user_interface.h"
#include <time.h>

#include <DHT.h>
#include <DHT_U.h>

#include <Firebase_ESP_Client.h>
#include <addons/TokenHelper.h>

#define DHTPIN 4 // Correlates to D2 pin on ESP board
#define DHTTYPE DHT11
DHT dht(DHTPIN, DHTTYPE);

#define FIREBASE_PROJECT_ID "acknowldger-2022"

#define API_KEY "AIzaSyDqIJRHdgebtM7rO0lD3oOtu0houb-bNoA"

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

bool signUp = false;
int dataMillis = 0;

WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, "sg.pool.ntp.org");

IPAddress localIP(192,168,1,1);
IPAddress gateway(192,168,1,255);
IPAddress subnet(255,255,255,0);
IPAddress dns1(8,8,8,8);
IPAddress dns2(8,8,4,4);

WebSocketsServer server = WebSocketsServer(80);


void onSocketEvent(uint8_t num, WStype_t type, uint8_t * payload, size_t length) {
  switch(type) {
    case WStype_DISCONNECTED:
      Serial.printf("[%u] Disconnected!\n", num);
      break;
    case WStype_CONNECTED:
      {
        IPAddress remote = server.remoteIP(num);
        Serial.printf("[%u] Connected from %d.%d.%d.%d url: %s\n", num, remote[0], remote[1], remote[2], remote[3], payload);
      }
      break;
    // case WStype_TEXT:
    //   Serial.printf("[%u] get Text: %s\n", num, payload);
    //   break;
    case WStype_BIN:
      Serial.printf("[%u] get binary length: %u\n", num, length);
      hexdump(payload, length);
      break;
    case WStype_TEXT:
      {
        Serial.printf("[%u] get Text: %s\n", num, payload);

        char* input = (char *) payload;

        DynamicJsonDocument creds(1024);
        deserializeJson(creds, input);

        const char* ssid = creds["ssid"];
        const char* password = creds["password"];
        Serial.println("Success: " + wifi_station_dhcpc_stop() ? "True" : "False");
        WiFi.begin(ssid, password);
        
        int8_t status = WiFi.waitForConnectResult(10000);

        server.sendTXT(num, String(status).c_str());

        if (status == 3) {
          server.close();
        }
      }
      break;
  }
}

void setup() {
  pinMode(D4, OUTPUT);
  Serial.begin(9600);
  Serial.println();
  Serial.println("Starting...");

  WiFi.mode(WIFI_AP_STA);
  
  // WiFi.disconnect(); // Reset For Dev Purposes

  // WiFi.beginSmartConfig();
  // WiFi.begin("YAP2201", "shikha123");
  WiFi.config(localIP, gateway, subnet);
  Serial.print("Setting soft-AP configuration ... ");
  Serial.println(WiFi.softAPConfig(localIP, gateway, subnet) ? "Ready" : "Failed!");

  Serial.print("Setting soft-AP ... ");
  Serial.println(WiFi.softAP("AIRXON", __null, 1, 1, 1) ? "Ready" : "Failed!");

  
  
  while (WiFi.status() != WL_CONNECTED) {
    Serial.println("0 Connections");
    while (WiFi.softAPgetStationNum() < 1) {
      delay(500);
    }

    Serial.println("1 Connection");

    server.begin();
    server.onEvent(onSocketEvent);
    server.enableHeartbeat(20, 10000, 10);

    while (WiFi.softAPgetStationNum() >= 1 && WiFi.status() != WL_CONNECTED) {
      server.loop();
    }
  }


  // while (WiFi.status() != WL_CONNECTED) {
  //   delay(500);
  //   Serial.print(".");
  // }

  Serial.println();

  Serial.println("Connected");

  Serial.print("IP Address: ");
  Serial.println(WiFi.localIP());

  dht.begin(); // DHT sensor setup
  Serial.println("DHT setup successful!");

  timeClient.begin();
  Serial.println("NTP server succesful!");

  Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);


  config.api_key = API_KEY;

  if (Firebase.signUp(&config, &auth, "", ""))
  {
    signUp = true;
  }
  else
      Serial.printf("%s\n", config.signer.signupError.message.c_str());


  config.token_status_callback = tokenStatusCallback; 
  

  fbdo.setBSSLBufferSize(2048, 2048);

  fbdo.setResponseSize(2048);

  Firebase.begin(&config, &auth);

  Firebase.reconnectWiFi(true);

  timeClient.begin();

}

void loop() {
  // timeClient.update();

  char data[100];

  unsigned long t = timeClient.getEpochTime();

  time_t raw = static_cast<time_t>(t);
  struct tm *tmp = localtime(&raw);

  strftime(data, 100, "%Y-%m-%dT%T%z", tmp);

  Serial.println(data + String(t));

  // delay(1000);

  digitalWrite(D4, HIGH);
  delay(1000);
  digitalWrite(D4, LOW);
  delay(1000);
  if (Firebase.ready() && signUp && (millis() - dataMillis > 100000 || dataMillis == 0)) {
    dataMillis = millis();

    FirebaseJson content;

    double temp = dht.readTemperature();
    double hum = dht.readHumidity();

    String path = auth.token.uid.c_str() + String("/test");


    content.set("fields/temp/doubleValue", temp);

    content.set("fields/hum/doubleValue", hum);

    if (Firebase.Firestore.createDocument(&fbdo, FIREBASE_PROJECT_ID, "", path.c_str(), content.raw()))
      Serial.printf("ok\n%s\n\n", fbdo.payload().c_str());
    else
      Serial.println(fbdo.errorReason());

  }

  delay(5000);


}
