import 'package:ac/colors.dart';
import 'package:ac/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gap/gap.dart';

class ChartsPage extends StatefulWidget {
  const ChartsPage({super.key});

  @override
  State<ChartsPage> createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> with TickerProviderStateMixin {
  TimePeriod _timePeriod = TimePeriod.day;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colors.main.base,
        body: ListView(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const Gap(20),
                    Row(
                      children: [
                        Text("Your AC Statistics", style: TextStyles.title2),
                      ],
                    ),
                    const Gap(20),
                    DefaultTabController(
                        length: 4,
                        child: Column(
                          children: [
                            Container(
                              // margin:
                              //     const EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.centerLeft,
                              height: 35,
                              // decoration:
                              //     BoxDecoration(color: colors.main.blue),
                              // height: MediaQuery.of(context).size.height * 0.5,
                              child: TabBar(
                                isScrollable: true,
                                indicator: BoxDecoration(
                                  color: colors.highlight,
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            colors.main.crust.withOpacity(0.5),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5))
                                  ],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                labelColor: colors.main.base,
                                unselectedLabelColor: colors.main.text,
                                // labelStyle: TextStyles.chip,
                                tabs: const [
                                  Tab(text: "Time"),
                                  Tab(text: "Humidity"),
                                  Tab(text: "Temperature"),
                                  Tab(text: "Energy"),
                                ],
                              ),
                            ),
                            const Gap(20),
                            Container(
                              // margin:
                              //     const EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.topCenter,
                              height: 35,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: TabBar(
                                // isScrollable: true,
                                controller: TabController(
                                  length: 4,
                                  vsync: this,
                                  animationDuration: kTabScrollDuration,
                                ),
                                onTap: (value) =>
                                    _timePeriod = TimePeriod.values[value],
                                indicator: BoxDecoration(
                                  color: colors.highlight,
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            colors.main.crust.withOpacity(0.5),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5))
                                  ],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                labelColor: colors.main.base,
                                unselectedLabelColor: colors.main.text,
                                // labelStyle: TextStyles.chip,
                                tabs: const [
                                  Tab(text: "Day"),
                                  Tab(text: "Week"),
                                  Tab(text: "Month"),
                                  Tab(text: "Year"),
                                ],
                              ),
                            ),
                            const Gap(20),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              // decoration:
                              //     BoxDecoration(color: colors.main.crust),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18)),
                                color: colors.main.overlay2,
                                child: Column(
                                  children: [
                                    // BarChart
                                  ],
                                ),
                              ),
                            )
                          ],
                        ))
                  ],
                ))
          ],
        ));
  }
}
