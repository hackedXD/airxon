#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <WiFiUdp.h>
#include <ArduinoJson.h>
#include <DHT.h>
#include <Firebase_ESP_Client.h>
#include <addons/TokenHelper.h>

#define SEED 1

#define DHTPIN 4  // Correlates to D2 pin on ESP board
#define DHTTYPE DHT11
DHT dht(4, 11);

#define FIREBASE_PROJECT_ID "acknowldger-2022"

#define API_KEY "AIzaSyDqIJRHdgebtM7rO0lD3oOtu0houb-bNoA"

char uuid[13] = "";

const char rootCACert[] = "-----BEGIN CERTIFICATE-----\n"
                          "MIIFVzCCAz+gAwIBAgINAgPlk28xsBNJiGuiFzANBgkqhkiG9w0BAQwFADBHMQsw\n"
                          "CQYDVQQGEwJVUzEiMCAGA1UEChMZR29vZ2xlIFRydXN0IFNlcnZpY2VzIExMQzEU\n"
                          "MBIGA1UEAxMLR1RTIFJvb3QgUjEwHhcNMTYwNjIyMDAwMDAwWhcNMzYwNjIyMDAw\n"
                          "MDAwWjBHMQswCQYDVQQGEwJVUzEiMCAGA1UEChMZR29vZ2xlIFRydXN0IFNlcnZp\n"
                          "Y2VzIExMQzEUMBIGA1UEAxMLR1RTIFJvb3QgUjEwggIiMA0GCSqGSIb3DQEBAQUA\n"
                          "A4ICDwAwggIKAoICAQC2EQKLHuOhd5s73L+UPreVp0A8of2C+X0yBoJx9vaMf/vo\n"
                          "27xqLpeXo4xL+Sv2sfnOhB2x+cWX3u+58qPpvBKJXqeqUqv4IyfLpLGcY9vXmX7w\n"
                          "Cl7raKb0xlpHDU0QM+NOsROjyBhsS+z8CZDfnWQpJSMHobTSPS5g4M/SCYe7zUjw\n"
                          "TcLCeoiKu7rPWRnWr4+wB7CeMfGCwcDfLqZtbBkOtdh+JhpFAz2weaSUKK0Pfybl\n"
                          "qAj+lug8aJRT7oM6iCsVlgmy4HqMLnXWnOunVmSPlk9orj2XwoSPwLxAwAtcvfaH\n"
                          "szVsrBhQf4TgTM2S0yDpM7xSma8ytSmzJSq0SPly4cpk9+aCEI3oncKKiPo4Zor8\n"
                          "Y/kB+Xj9e1x3+naH+uzfsQ55lVe0vSbv1gHR6xYKu44LtcXFilWr06zqkUspzBmk\n"
                          "MiVOKvFlRNACzqrOSbTqn3yDsEB750Orp2yjj32JgfpMpf/VjsPOS+C12LOORc92\n"
                          "wO1AK/1TD7Cn1TsNsYqiA94xrcx36m97PtbfkSIS5r762DL8EGMUUXLeXdYWk70p\n"
                          "aDPvOmbsB4om3xPXV2V4J95eSRQAogB/mqghtqmxlbCluQ0WEdrHbEg8QOB+DVrN\n"
                          "VjzRlwW5y0vtOUucxD/SVRNuJLDWcfr0wbrM7Rv1/oFB2ACYPTrIrnqYNxgFlQID\n"
                          "AQABo0IwQDAOBgNVHQ8BAf8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4E\n"
                          "FgQU5K8rJnEaK0gnhS9SZizv8IkTcT4wDQYJKoZIhvcNAQEMBQADggIBAJ+qQibb\n"
                          "C5u+/x6Wki4+omVKapi6Ist9wTrYggoGxval3sBOh2Z5ofmmWJyq+bXmYOfg6LEe\n"
                          "QkEzCzc9zolwFcq1JKjPa7XSQCGYzyI0zzvFIoTgxQ6KfF2I5DUkzps+GlQebtuy\n"
                          "h6f88/qBVRRiClmpIgUxPoLW7ttXNLwzldMXG+gnoot7TiYaelpkttGsN/H9oPM4\n"
                          "7HLwEXWdyzRSjeZ2axfG34arJ45JK3VmgRAhpuo+9K4l/3wV3s6MJT/KYnAK9y8J\n"
                          "ZgfIPxz88NtFMN9iiMG1D53Dn0reWVlHxYciNuaCp+0KueIHoI17eko8cdLiA6Ef\n"
                          "MgfdG+RCzgwARWGAtQsgWSl4vflVy2PFPEz0tv/bal8xa5meLMFrUKTX5hgUvYU/\n"
                          "Z6tGn6D/Qqc6f1zLXbBwHSs09dR2CQzreExZBfMzQsNhFRAbd03OIozUhfJFfbdT\n"
                          "6u9AWpQKXCBfTkBdYiJ23//OYb2MI3jSNwLgjt7RETeJ9r/tSQdirpLsQBqvFAnZ\n"
                          "0E6yove+7u7Y/9waLd64NnHi/Hm3lCXRSHNboTXns5lndcEZOitHTtNCjv0xyBZm\n"
                          "2tIMPNuzjsmhDYAPexZ3FL//2wmUspO8IFgV6dtxQ/PeEMMA3KgqlbbC1j+Qa3bb\n"
                          "bP6MvPJwNQzcmRk13NfIRmPVNnGuV/u3gm3c\n"
                          "-----END CERTIFICATE-----\n";

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

bool signUp = false;
int dataMillis = 0;

IPAddress localIP(192, 168, 1, 1);
IPAddress gateway(192, 168, 1, 255);
IPAddress subnet(255, 255, 255, 0);


WiFiUDP udp;

char packet[1024];

void genRandomUUID() {
  char digits[] = "abcdefghijklmnopqrstuvwxyz123456789";
  for (int i = 0; i < sizeof(uuid) - 1; i++) {
    uuid[i] = digits[random(sizeof(digits))];
  }

  uuid[sizeof(uuid) - 1] = '\0';
} 

char* genRandomUUID(int len) {
  char* digits = "abcdefghijklmnopqrstuvwxyz0123456789";
  char* value = "";
  while (len >= 0) {
    value += digits[random(sizeof(digits))];
    len--;
    delay(10);
  }

  return value;
}


void handlePacket(int size) {
  Serial.printf("Received %d bytes from %s, port %d\n", size, udp.remoteIP().toString().c_str(), udp.remotePort());
  int len = udp.read(packet, 1024);
  if (len > 0) {
    packet[len] = '\0';
  }
  Serial.printf("UDP packet contents: %s\n", packet);

  DynamicJsonDocument creds(1024);
  deserializeJson(creds, packet);

  const char* ssid = creds["ssid"];
  const char* password = creds["password"];

  Serial.printf("SSID: %s, PASSWORD: %s\n", ssid, password);

  WiFi.begin(ssid, password);

  int8_t status = WiFi.waitForConnectResult(30000);

  Serial.printf("Status: %d\n", status);

  udp.beginPacket(udp.remoteIP(), udp.remotePort());
  Serial.println(uuid);
  if (status != WL_CONNECTED) {
    WiFi.disconnect();
    udp.write("-1");
  } else {
    udp.write(uuid);
  }


  udp.endPacket();
}

void setup() {
  pinMode(D4, OUTPUT);
  Serial.begin(9600);
  Serial.println();
  randomSeed(SEED);
  Serial.println("Starting...");
  Serial.println(sizeof(uuid));
  genRandomUUID();
  
  Serial.println(uuid);

  dht.begin();  // DHT sensor setup
  Serial.println("DHT Setup Complete!");

  WiFi.mode(WIFI_AP_STA);

  // WiFi.disconnect(); // Reset For Dev Purposes
  // WiFi.begin("YAP2201", "shikha123");

  Serial.print("Setting soft-AP configuration ... ");
  Serial.println(WiFi.softAPConfig(localIP, gateway, subnet) ? "Ready" : "Failed!");

  Serial.print("Setting soft-AP ... ");
  Serial.println(WiFi.softAP("AIRXON", __null, 1, 1, 1) ? "Ready" : "Failed!");


  udp.begin(5111);
  while (WiFi.status() != WL_CONNECTED) {
    Serial.println("0 Connections");
    // delay(500);
    while (WiFi.softAPgetStationNum() < 1) {
      delay(500);
    }

    Serial.println("1 Connection");

    while (WiFi.softAPgetStationNum() >= 1 && WiFi.status() != WL_CONNECTED) {
      int packetSize = udp.parsePacket();
      if (packetSize) {
        handlePacket(packetSize);
      }
    }
  }

  Serial.println();

  Serial.println("Connected");

  Serial.print("IP Address: ");
  Serial.println(WiFi.localIP());

  // while (!timeClient.isTimeSet()) {
  //   Serial.print(".");
  //   timeClient.update();
  //   delay(1000);
  // }
  // Serial.println();

  Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);

  config.cert.data = rootCACert;

  config.api_key = API_KEY;

  Firebase.reconnectWiFi(true);
  fbdo.setResponseSize(4096);

  config.token_status_callback = tokenStatusCallback;

  auth.user.email = "test@test.com";
  auth.user.password = "test123";


  Firebase.begin(&config, &auth);

  // timeClient.begin();
}

void loop() {
  // timeClient.update();

  // Serial.printf("Time: %s, Is Set? %s\n", timeClient.getFormattedTime(), timeClient.isTimeSet() ? "True" : "False");


  if (Firebase.ready() && ((millis() - dataMillis > 60 * 1000) || (dataMillis == 0))) {
    dataMillis = millis();

    FirebaseJson content;

    double temp = dht.readTemperature();
    double hum = dht.readHumidity();

    time_t now = Firebase.getCurrentTime();
    char buf[21];
    strftime(buf, sizeof buf, "%FT%TZ", gmtime(&now));

    content.set("fields/temp/doubleValue", temp);
    content.set("fields/hum/doubleValue", hum);
    content.set("fields/time/timestampValue", buf);



    if (Firebase.Firestore.createDocument(&fbdo, FIREBASE_PROJECT_ID, "", uuid, content.raw()))
      Serial.printf("Firestore: Sent packet.\n");
    else
      Serial.println(fbdo.errorReason());
  }
  delay(500);
}
