import 'dart:async';
import 'dart:core';

import 'package:ac/colors.dart';
import 'package:ac/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final db = FirebaseFirestore.instance;
  double temp = 0;
  double hum = 0;
  Duration runningTime = Duration.zero;
  double estEnergy = 0;
  double avgTemp = 0;
  double avgHum = 0;

  @override
  void initState() {
    getData();
    // Timer t =
    //     Timer.periodic(const Duration(minutes: 1), (Timer s) => getData());
  }

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uuid = prefs.getString("uuid");
    // prefs.remove("uuid");
    print("UUID is " + (uuid ?? "not found"));
    // if (uuid != null) {
    //   await db.collection(uuid).limit(1).get().then((value) {
    //     for (var doc in value.docs) {
    //       print(doc.data());
    //     }
    //   });
    // }
    if (uuid != null) {
      db
          .collection(uuid)
          .orderBy("time", descending: true)
          .snapshots()
          .listen((event) async {
        if (this.mounted) {
          Duration val = await calculateRunningTime(event.docs);
          setState(() {
            temp = event.docs[0].data()["temp"];
            hum = event.docs[0].data()["hum"];
            runningTime = val;
            estEnergy = runningTime.inMinutes / 60 * 0.544;
            for (var doc in event.docs
                .take(10 <= event.docs.length ? 10 : event.docs.length)) {
              avgTemp += (doc.data())["temp"];
              avgHum += (doc.data())["hum"];
            }
            avgTemp /= 10 <= event.docs.length ? 10 : event.docs.length;
            avgHum /= 10 <= event.docs.length ? 10 : event.docs.length;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colors.main.base,
        body: ListView(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(children: [
                  const Gap(30),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "Good ${DateTime.now().hour > 12 ? "Morning" : "Evening"}",
                              style: TextStyles.subtitle),
                          const Gap(3),
                          Text("Welcome to your AC", style: TextStyles.title2)
                        ],
                      )
                    ],
                  ),
                  const Gap(20),
                  DefaultTabController(
                      length: 2,
                      child: Column(children: [
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 55),
                            height: 35,
                            decoration: BoxDecoration(
                                color: colors.main.surface0,
                                borderRadius: BorderRadius.circular(20)),
                            child: TabBar(
                              indicator: BoxDecoration(
                                color: colors.highlight,
                                boxShadow: [
                                  BoxShadow(
                                      color: colors.main.crust.withOpacity(0.5),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5))
                                ],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              labelColor: colors.main.base,
                              unselectedLabelColor: colors.main.text,
                              tabs: const [
                                Tab(text: "Temperature"),
                                Tab(text: "Humidity")
                              ],
                            )),
                        const Gap(20),
                        Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            // decoration:
                            //     BoxDecoration(color: colors.main.surface2),
                            child: TabBarView(
                              children: [
                                Center(
                                  child: SleekCircularSlider(
                                      initialValue: temp,
                                      min: 0,
                                      max: 40,
                                      appearance: CircularSliderAppearance(
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.39,
                                          counterClockwise: false,
                                          startAngle: 120,
                                          angleRange: 300,
                                          animDurationMultiplier: 1.2,
                                          infoProperties: InfoProperties(
                                              bottomLabelText: "Temp.",
                                              bottomLabelStyle:
                                                  TextStyles.subtitle.copyWith(
                                                      fontSize: 20,
                                                      color: colors.highlight,
                                                      fontWeight:
                                                          FontWeight.w700),
                                              modifier: (percentage) =>
                                                  "${percentage.toStringAsFixed(1)}°C",
                                              mainLabelStyle: TextStyles.title
                                                  .copyWith(fontSize: 40)),
                                          customWidths: CustomSliderWidths(
                                              handlerSize: 0,
                                              trackWidth: 18,
                                              progressBarWidth: 18),
                                          customColors: CustomSliderColors(
                                            trackColor: colors.main.crust,
                                            progressBarColors: [
                                              colors.main.teal,
                                              colors.main.sky,
                                              colors.main.blue,
                                              colors.main.lavender,
                                              // colors.main.mauve,
                                              colors.main.pink,
                                              colors.main.flamingo,
                                              colors.main.rosewater,
                                              colors.main.yellow,
                                              // Colors.black,
                                              // Colors.white,
                                            ],
                                            dynamicGradient: true,
                                            gradientStartAngle: 60,
                                            gradientEndAngle: 420,
                                          ))),
                                ),
                                Center(
                                  child: SleekCircularSlider(
                                      initialValue: hum,
                                      min: 0,
                                      max: 100,
                                      appearance: CircularSliderAppearance(
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.39,
                                          counterClockwise: false,
                                          startAngle: 120,
                                          angleRange: 300,
                                          animDurationMultiplier: 1.2,
                                          infoProperties: InfoProperties(
                                              bottomLabelText: "Humidity",
                                              bottomLabelStyle:
                                                  TextStyles.subtitle.copyWith(
                                                      fontSize: 20,
                                                      color: colors.highlight,
                                                      fontWeight:
                                                          FontWeight.w700),
                                              modifier: (percentage) =>
                                                  "${percentage.toStringAsFixed(0)}%",
                                              mainLabelStyle: TextStyles.title
                                                  .copyWith(fontSize: 40)),
                                          customWidths: CustomSliderWidths(
                                              handlerSize: 0,
                                              trackWidth: 18,
                                              progressBarWidth: 18),
                                          customColors: CustomSliderColors(
                                            trackColor: colors.main.crust,
                                            progressBarColors: [
                                              colors.main.sky,
                                              colors.main.sapphire,
                                              colors.main.teal,
                                              colors.main.green,
                                              // Colors.black,
                                              // Colors.white,
                                            ],
                                            dynamicGradient: true,
                                            gradientStartAngle: 60,
                                            gradientEndAngle: 420,
                                          ))),
                                ),
                              ],
                            ))
                      ])),
                  Column(
                    children: [
                      const Gap(12),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Running Time: ", style: TextStyles.main1),
                            Text(
                                (runningTime.inHours != 0)
                                    ? runningTime.inHours.toString() + "h "
                                    : "" +
                                        runningTime.inMinutes
                                            .remainder(60)
                                            .toString() +
                                        "m",
                                style: TextStyles.main1
                                    .copyWith(fontWeight: FontWeight.w900)),
                          ]),
                      const Gap(12),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Est. Energy Usage: ",
                                style: TextStyles.main1),
                            Text(estEnergy.toStringAsFixed(2) + " kwh",
                                style: TextStyles.main1
                                    .copyWith(fontWeight: FontWeight.w900)),
                          ]),
                      const Gap(12),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Avg. Temp: ", style: TextStyles.main1),
                            Text("${avgTemp.toStringAsFixed(2)}°C",
                                style: TextStyles.main1
                                    .copyWith(fontWeight: FontWeight.w900)),
                          ]),
                      const Gap(12),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Avg. Humidity: ", style: TextStyles.main1),
                            Text("${avgHum.toStringAsFixed(2)}%",
                                style: TextStyles.main1
                                    .copyWith(fontWeight: FontWeight.w900)),
                          ]),
                    ],
                  )
                ])),
            // MaterialButton(
            //   color: colors.highlight,
            //   elevation: 0,
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(20)),
            //   child: Text(
            //     "Wipe",
            //     style: TextStyle(color: colors.main.base, fontSize: 16),
            //   ),
            //   onPressed: () async {
            //     SharedPreferences prefs = await SharedPreferences.getInstance();

            //     prefs.remove("uuid");
            //     prefs.remove("wantedTemp");
            //     print("wiped");
            //   },
            // ),
            // MaterialButton(
            //   color: colors.highlight,
            //   elevation: 0,
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(20)),
            //   child: Text(
            //     "Set UUID",
            //     style: TextStyle(color: colors.main.base, fontSize: 16),
            //   ),
            //   onPressed: () async {
            //     SharedPreferences prefs = await SharedPreferences.getInstance();

            //     prefs.setString("uuid", "42cfmyqmit2x");
            //   },
            // )
          ],
        ));
  }

  Future<Duration> calculateRunningTime(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double wantedTemp = prefs.getDouble("wantedTemp") ?? 1;
    int runningTime = 0;
    int i = 0;

    while (i < docs.length) {
      if ((docs[i].data())["temp"] >= wantedTemp - 1 &&
          (docs[i].data())["temp"] <= wantedTemp + 1) {
        runningTime += 1;
      } else {
        break;
      }
      i++;
    }

    prefs.setDouble("energy", runningTime / 60 * 0.544);

    return Duration(minutes: runningTime);
  }
}
