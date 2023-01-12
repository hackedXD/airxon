import 'dart:async';

import 'package:ac/colors.dart';
import 'package:ac/components/charts/hum_chart.dart';
import 'package:ac/components/charts/time_chart.dart';
import 'package:ac/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChartsPage extends StatefulWidget {
  const ChartsPage({super.key});

  @override
  State<ChartsPage> createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> with TickerProviderStateMixin {
  TimePeriod _timePeriod = TimePeriod.Hour;
  double estPrice = 0.0;
  double estUsage = 0.0;

  @override
  void initState() {
    super.initState();
    getData(Timer(Duration(minutes: 1), () => null));
    Timer.periodic(Duration(minutes: 1), getData);
  }

  void getData(Timer timer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double usage = prefs.getDouble("energy") ?? 0.0;
    if (this.mounted) {
      setState(() {
        estPrice = usage * 0.2895;
        estUsage = usage;
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
                child: Column(
                  children: [
                    const Gap(55),
                    Row(
                      children: [
                        Text(
                          "Your AC Statistics",
                          style: TextStyles.base.copyWith(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Gap(5),
                      ],
                    ),
                    const Gap(20),
                    DefaultTabController(
                        length: 3,
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
                                  Tab(text: "Temperature"),
                                  Tab(text: "Humidity"),
                                  Tab(text: "Energy"),
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
                                  color: colors.main.crust,
                                  child: TabBarView(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Column(children: [
                                          timePeriodDropdown(),
                                          const Gap(5),
                                          TempChart(scope: _timePeriod),
                                        ]),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Column(children: [
                                          timePeriodDropdown(),
                                          const Gap(5),
                                          HumChart(scope: _timePeriod),
                                        ]),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.all(30),
                                          child: Column(
                                            children: [
                                              Text(
                                                  "Your Current Est. AC Energy Usage is",
                                                  style: TextStyles.base
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15)),
                                              const Gap(5),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                        estUsage.toStringAsFixed(
                                                            2),
                                                        style: TextStyles.base
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 50)),
                                                    const Gap(5),
                                                    Text("kWh",
                                                        style: TextStyles.base
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20)),
                                                    Divider(),
                                                    Icon(Iconsax.electricity,
                                                        size: 35,
                                                        color:
                                                            colors.main.yellow)
                                                  ]),
                                              const Gap(5),
                                              Text("with an est. cost of",
                                                  style: TextStyles.base
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15)),
                                              const Gap(5),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      estPrice
                                                          .toStringAsFixed(2),
                                                      style: TextStyles.base
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 50)),
                                                  const Gap(5),
                                                  Text("SGD",
                                                      style: TextStyles.base
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20)),
                                                  const Gap(3),
                                                  Icon(Iconsax.dollar_circle,
                                                      size: 35,
                                                      color: colors.main.green)
                                                ],
                                              )
                                            ],
                                          )),
                                    ],
                                  )),
                            )
                          ],
                        ))
                  ],
                ))
          ],
        ));
  }

  Widget timePeriodDropdown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text("Time Period: ", style: TextStyles.base),
        const Gap(5),
        Container(
            decoration: BoxDecoration(
              color: colors.main.surface1,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 30.0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 7),
              child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                style: TextStyles.base.copyWith(
                  // color: colors.main.base,
                  fontWeight: FontWeight.bold,
                ),
                dropdownColor: colors.main.surface1,
                alignment: Alignment.center,
                iconSize: 0,
                borderRadius: BorderRadius.circular(20.0),
                items: TimePeriod.values
                    .map((e) => DropdownMenuItem(
                          child: Text(e.name),
                          value: e,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _timePeriod = value!;
                  });
                },
                isExpanded: false,
                value: _timePeriod,
              )),
            ))
      ],
    );
  }
}
