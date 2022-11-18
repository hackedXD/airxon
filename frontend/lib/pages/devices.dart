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
import 'package:web_socket_channel/io.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container(
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                !localEnabled
                                    ? Text("Error: Not Enabled",
                                        style: TextStyles.subtitle
                                            .copyWith(color: colors.main.red))
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
                              localEnabled = await WiFiForIoTPlugin.isEnabled();
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
              security: NetworkSecurity.NONE, isHidden: true, joinOnce: true);
          await WiFiForIoTPlugin.forceWifiUsage(true);

          print("helo, is connected? ${connection}");
          if (connection) {
            await Future.delayed(Duration(seconds: 1));

            var channel = IOWebSocketChannel(
                await WebSocket.connect("ws://192.168.1.1:80")
                    .timeout(Duration(mil: 10)));

            await showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                isScrollControlled: true,
                isDismissible: true,
                builder: (context) {
                  final MediaQueryData mediaQueryData = MediaQuery.of(context);
                  return Padding(
                      padding: mediaQueryData.viewInsets,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        const Gap(50),
                        Text("Enter Wifi Credentials", style: TextStyles.title),
                        const Gap(25),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: TextField(
                            style: TextStyle(color: colors.main.text),
                            cursorColor: colors.main.text,
                            controller: _ssidController,
                            decoration: InputDecoration(
                                fillColor: colors.main.text,
                                labelStyle: TextStyle(color: colors.main.text),
                                floatingLabelStyle:
                                    TextStyle(color: colors.main.text),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                labelText: "SSID"),
                          ),
                        ),
                        const Gap(10),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: TextField(
                            obscureText: true,
                            style: TextStyle(color: colors.main.text),
                            cursorColor: colors.main.text,
                            controller: _passwordController,
                            decoration: InputDecoration(
                                fillColor: colors.main.text,
                                labelStyle: TextStyle(color: colors.main.text),
                                floatingLabelStyle:
                                    TextStyle(color: colors.main.text),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                labelText: "Password"),
                          ),
                        ),
                        const Gap(15),
                        RoundedLoadingButton(
                          onPressed: () {
                            channel.sink.add(jsonEncode({
                              "ssid": _ssidController.text,
                              "password": _passwordController.text
                            }));

                            channel.stream.listen((message) async {
                              if (message == "3") {
                                _wifiController.success();
                                Navigator.of(context).pop();
                                _btnController.reset();
                              } else {
                                _wifiController.error();
                                await Future.delayed(Duration(seconds: 1));
                                _wifiController.reset();
                              }
                            });
                          },
                          controller: _btnController,
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
                                color: colors.main.base, fontSize: 16),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off,
              size: 55,
              color: colors.main.text,
            ),
            const Gap(5),
            Text(
              "No wifi connection",
              style: TextStyles.base.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(5),
            Text(
              "Please connect to a wifi network to connect to a device",
              style: TextStyles.base.copyWith(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
