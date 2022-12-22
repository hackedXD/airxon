import 'dart:convert';
import 'dart:io';

import 'package:ac/colors.dart';
import 'package:ac/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gap/gap.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:udp/udp.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wifi_iot/wifi_iot.dart';

class DevicesPage extends StatefulWidget {
  const DevicesPage({super.key});

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final _ssidController = TextEditingController();
  final _passwordController = TextEditingController();
  final RoundedLoadingButtonController _wifiController =
      RoundedLoadingButtonController();
  final TextEditingController _tempController = TextEditingController();
  bool showDevices = false;
  double wantedTemp = 0.0;

  @override
  void initState() {
    super.initState();
    loadDevices();
    loadWantedTemp();
  }

  Future<void> loadDevices() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      showDevices = (prefs.getString("uuid") != null);
    });
  }

  Future<void> loadWantedTemp() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      wantedTemp = prefs.getDouble("wantedTemp") ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showDevices
        ? showNoWifi()
        : Container(
            child: Center(
                child: RoundedLoadingButton(
              controller: _btnController,
              color: colors.highlight,
              successColor: colors.highlight,
              onPressed: () async {
                // await WiFiForIoTPlugin.connect("AIRXON",
                //     password:
                //         "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
                //     security: NetworkSecurity.WPA,
                //     isHidden: true,
                //     joinOnce: true);
                bool isEnabled = await WiFiForIoTPlugin.isEnabled();

                if (!isEnabled) {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        bool localEnabled = true;
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog(
                              title: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      !localEnabled
                                          ? Text("Error: Not Enabled",
                                              style: TextStyles.subtitle
                                                  .copyWith(
                                                      color: colors.main.red))
                                          : const Gap(5),
                                      const Gap(5),
                                      Text("WiFi Not Enabled",
                                          style: TextStyles.title2)
                                    ],
                                  )),
                              content: Text("Please enable WiFi to continue",
                                  style: TextStyles.subtitle),
                              actions: [
                                MaterialButton(
                                  color: colors.highlight,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text(
                                    "Continue",
                                    style: TextStyle(
                                        color: colors.main.base, fontSize: 16),
                                  ),
                                  onPressed: () async {
                                    localEnabled =
                                        await WiFiForIoTPlugin.isEnabled();
                                    print("enabled: ${localEnabled}");

                                    if (localEnabled) {
                                      Navigator.of(context).pop();
                                    } else {
                                      setState(() {
                                        localEnabled = false;
                                      });
                                    }
                                  },
                                )
                              ],
                            );
                          },
                        );
                      });
                }

                bool connection = await WiFiForIoTPlugin.connect("AIRXON",
                    security: NetworkSecurity.NONE,
                    isHidden: true,
                    joinOnce: true);
                await WiFiForIoTPlugin.forceWifiUsage(true);

                print("helo, is connected? ${connection}");
                if (connection) {
                  await Future.delayed(Duration(seconds: 1));

                  var endpoint = Endpoint.unicast(
                      InternetAddress("192.168.1.1"),
                      port: Port(5111));

                  bool isConnected = await WiFiForIoTPlugin.isConnected();

                  while (!isConnected) {
                    await Future.delayed(Duration(milliseconds: 500));
                    isConnected = await WiFiForIoTPlugin.isConnected();
                  }

                  var udpServer =
                      await UDP.bind(Endpoint.any(port: Port(5111)));
                  bool processingData = false;

                  await showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      isScrollControlled: true,
                      isDismissible: false,
                      builder: (context) {
                        final MediaQueryData mediaQueryData =
                            MediaQuery.of(context);
                        return Padding(
                            padding: mediaQueryData.viewInsets,
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Gap(50),
                                  Text("Enter Wifi Credentials",
                                      style: TextStyles.title),
                                  const Gap(25),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: TextField(
                                      style: TextStyle(color: colors.main.text),
                                      cursorColor: colors.main.text,
                                      controller: _ssidController,
                                      decoration: InputDecoration(
                                          fillColor: colors.main.text,
                                          labelStyle: TextStyle(
                                              color: colors.main.text),
                                          floatingLabelStyle: TextStyle(
                                              color: colors.main.text),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          labelText: "SSID"),
                                    ),
                                  ),
                                  const Gap(10),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: TextField(
                                      obscureText: true,
                                      style: TextStyle(color: colors.main.text),
                                      cursorColor: colors.main.text,
                                      controller: _passwordController,
                                      decoration: InputDecoration(
                                          fillColor: colors.main.text,
                                          labelStyle: TextStyle(
                                              color: colors.main.text),
                                          floatingLabelStyle: TextStyle(
                                              color: colors.main.text),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          labelText: "Password"),
                                    ),
                                  ),
                                  const Gap(15),
                                  RoundedLoadingButton(
                                    onPressed: () {
                                      if (!processingData) {
                                        processingData = true;

                                        udpServer.send(
                                            jsonEncode({
                                              "ssid": _ssidController.text,
                                              "password":
                                                  _passwordController.text
                                            }).codeUnits,
                                            endpoint);

                                        udpServer
                                            .asStream(
                                                timeout: Duration(seconds: 35))
                                            .listen((datagram) async {
                                          if (datagram != null) {
                                            String message =
                                                String.fromCharCodes(
                                                    datagram.data);
                                            print(message);
                                            if (message == "-1") {
                                              print(message);
                                              _wifiController.error();
                                              _wifiController.reset();
                                            } else {
                                              Navigator.of(context).pop();
                                              _btnController.success();
                                              _btnController.reset();
                                              _wifiController.reset();
                                              _ssidController.text = "";
                                              _passwordController.text = "";
                                              udpServer.close();
                                              final prefs =
                                                  await SharedPreferences
                                                      .getInstance();

                                              setState(() {
                                                prefs.setString(
                                                    "uuid", message);
                                                showDevices = true;
                                              });
                                              print("reached");
                                            }
                                          }
                                          processingData = false;
                                        });
                                      }
                                    },
                                    controller: _wifiController,
                                    color: colors.highlight,
                                    successColor: colors.highlight,
                                    elevation: 0,
                                    height: 35,
                                    width: 160,
                                    loaderSize: 20,
                                    borderRadius: 20,
                                    child: Text(
                                      "Connect",
                                      style: TextStyle(
                                          color: colors.main.base,
                                          fontSize: 16),
                                    ),
                                  ),
                                  const Gap(75),
                                ]));
                      });
                } else {
                  _btnController.error();
                  await Future.delayed(Duration(seconds: 1));
                  _btnController.reset();
                }
              },
              elevation: 0,
              height: 35,
              width: 160,
              loaderSize: 20,
              borderRadius: 20,
              child: Text(
                "Add a new device",
                style: TextStyle(color: colors.main.base, fontSize: 16),
              ),
            )),
          );
  }

  Widget showNoWifi() {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Gap(75),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Gap(20),
                Row(
                  children: [
                    Text(
                      "Device Added ",
                      style: TextStyles.base.copyWith(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.check_circle, size: 20, color: colors.main.green)
                  ],
                ),
              ],
            ),
            const Gap(30),
            Card(
                color: colors.main.crust,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                child: SizedBox(
                    height: 300,
                    width: MediaQuery.of(context).size.width - 40,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Gap(25),
                          Text("Your Current Wanted AC Temp is",
                              style: TextStyles.base.copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                          const Gap(5),
                          Text(wantedTemp.toString(),
                              style: TextStyles.title.copyWith(fontSize: 65)),
                          const Gap(20),
                          MaterialButton(
                            color: colors.highlight,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              "Change Temperature",
                              style: TextStyle(
                                  color: colors.main.base, fontSize: 16),
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  isDismissible: true,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20))),
                                  builder: (ctx) {
                                    return Padding(
                                        padding: MediaQuery.of(context)
                                            .viewInsets
                                            .copyWith(left: 20, right: 20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Gap(50),
                                            TextFormField(
                                              controller: _tempController,
                                              // initialValue: wantedTemp.toString(),
                                              onChanged: (value) {},
                                              decoration: InputDecoration(
                                                label: Text("Input a new temp"),
                                                border: OutlineInputBorder(),
                                              ),
                                              keyboardType: TextInputType
                                                  .numberWithOptions(
                                                      decimal: true),
                                            ),
                                            const Gap(5),
                                            MaterialButton(
                                              color: colors.highlight,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Text(
                                                "Submit",
                                                style: TextStyle(
                                                    color: colors.main.base,
                                                    fontSize: 16),
                                              ),
                                              onPressed: () async {
                                                SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                await prefs.setDouble(
                                                    "wantedTemp",
                                                    double.parse(
                                                        _tempController.text));
                                                setState(() {
                                                  wantedTemp = double.parse(
                                                      _tempController.text);
                                                });
                                                Navigator.pop(ctx);
                                              },
                                            ),
                                            const Gap(50),
                                          ],
                                        ));
                                  });
                            },
                          ),
                        ]))),
          ],
        ),
      ),
    );
  }
}
