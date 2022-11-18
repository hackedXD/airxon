import 'package:ac/colors.dart';
import 'package:ac/utils.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                                      initialValue: 40,
                                      min: 10,
                                      max: 40,
                                      appearance: CircularSliderAppearance(
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.39,
                                          counterClockwise: false,
                                          startAngle: 120,
                                          angleRange: 300,
                                          animDurationMultiplier: 0.9,
                                          infoProperties: InfoProperties(
                                              bottomLabelText: "Temp.",
                                              bottomLabelStyle:
                                                  TextStyles.subtitle.copyWith(
                                                      fontSize: 20,
                                                      color: colors.highlight,
                                                      fontWeight:
                                                          FontWeight.w700),
                                              modifier: (percentage) =>
                                                  "${percentage.toStringAsPrecision(2)}°C",
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
                                      initialValue: 65,
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
                                          animDurationMultiplier: 0.9,
                                          infoProperties: InfoProperties(
                                              bottomLabelText: "Humidity",
                                              bottomLabelStyle:
                                                  TextStyles.subtitle.copyWith(
                                                      fontSize: 20,
                                                      color: colors.highlight,
                                                      fontWeight:
                                                          FontWeight.w700),
                                              modifier: (percentage) =>
                                                  "${percentage.toStringAsPrecision(2)}%",
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
                            Text("2h 1m",
                                style: TextStyles.main1
                                    .copyWith(fontWeight: FontWeight.w900)),
                          ]),
                      const Gap(12),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Est. Energy Usage: ",
                                style: TextStyles.main1),
                            Text("50 watts",
                                style: TextStyles.main1
                                    .copyWith(fontWeight: FontWeight.w900)),
                          ]),
                      const Gap(12),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Avg. Temp: ", style: TextStyles.main1),
                            Text("23°C",
                                style: TextStyles.main1
                                    .copyWith(fontWeight: FontWeight.w900)),
                          ]),
                      const Gap(12),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Avg. Humidity: ", style: TextStyles.main1),
                            Text("72%",
                                style: TextStyles.main1
                                    .copyWith(fontWeight: FontWeight.w900)),
                          ]),
                    ],
                  )
                ]))
          ],
        ));
  }
}