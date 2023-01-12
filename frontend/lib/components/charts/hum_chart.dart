import 'package:ac/colors.dart';
import 'package:ac/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HumChart extends StatefulWidget {
  const HumChart({super.key, required this.scope});

  final TimePeriod scope;

  @override
  State<HumChart> createState() => _HumChartState();
}

class _HumChartState extends State<HumChart> {
  final db = FirebaseFirestore.instance;
  TimePeriod prevScope = TimePeriod.Hour;
  bool dataLoaded = false;
  List<FlSpot> data = [];
  double prefferedTemp = 0;
  // int bottomCounter = 0;

  @override
  void initState() {
    super.initState();
    prevScope = widget.scope;
    initializeDateFormatting("en_SG", null);
    getData();
  }

  Future<void> getData() async {
    print(widget.scope.name);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uuid = prefs.getString("uuid") ?? "";
    prefferedTemp = prefs.getDouble("wantedTemp") ?? 0;

    if (uuid.isEmpty) return;

    db
        .collection(uuid)
        .orderBy("time", descending: true)
        .snapshots()
        .listen((event) {
      if (this.mounted) {
        setState(() {
          data = event.docs
              .where((element) =>
                  (element.data())["time"].millisecondsSinceEpoch >
                  DateTime.now()
                      .subtract(widget.scope.duration)
                      .millisecondsSinceEpoch)
              .map((e) => FlSpot(
                  (e.data())["time"].millisecondsSinceEpoch.toDouble(),
                  (e.data())["hum"].toDouble()))
              .toList();
          dataLoaded = true;
        });
      }
    });
  }

  Widget _mainChart() {
    return LineChart(
      _chartData(),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    // if (value == meta.min) {
    //   bottomCounter = 0;
    // }

    if (value == meta.max || value == meta.min) {
      return Container();
    }

    DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    // bottomCounter++;

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(DateFormat(widget.scope.dateFormat).format(date),
          style: TextStyles.base.copyWith(fontSize: 12)),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        "${value.toInt()}%",
        style: TextStyles.base.copyWith(fontSize: 12),
      ),
    );
  }

  LineChartData _chartData() {
    return LineChartData(
      minX: DateTime.now()
          .subtract(widget.scope.duration)
          .millisecondsSinceEpoch
          .toDouble(),
      maxX: DateTime.now().millisecondsSinceEpoch.toDouble(),
      // minX: 1,
      // maxX: 40,
      minY: 0,
      maxY: 100,
      borderData: FlBorderData(
          border: Border(
        bottom: BorderSide(color: colors.main.overlay2, width: 1),
        left: BorderSide(color: colors.main.overlay2, width: 1),
      )),
      gridData: FlGridData(
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) =>
            FlLine(color: colors.main.text, strokeWidth: 1),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: data,
          isCurved: false,
          barWidth: 2,
          color: colors.main.teal,
          dotData: FlDotData(
            show: false,
          ),
        ),
      ],
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        // bottomTitles: AxisTitles(
        //   sideTitles: SideTitles(showTitles: false),
        // ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 20,
              getTitlesWidget: leftTitleWidgets),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            interval: widget.scope.interval,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        // leftTitles: AxisTitles(
        //   sideTitles: SideTitles(
        //     showTitles: true,
        //     interval: 1,
        //     getTitlesWidget: leftTitleWidgets,
        //     reservedSize: 42,
        //   ),
        // ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (prevScope != widget.scope) {
      prevScope = widget.scope;
      dataLoaded = false;
      getData();
    }

    return (!dataLoaded)
        ? SizedBox(
            child: Center(
                child: LoadingAnimationWidget.inkDrop(
                    color: colors.highlight, size: 40)),
            height: 200)
        : (data.length <= 0)
            ? SizedBox(
                child: Center(
                    child: Text(
                  "No data available",
                  style: TextStyles.title2,
                )),
                height: 200)
            : SizedBox(
                height: MediaQuery.of(context).size.height * 0.30,
                child: Padding(
                    padding: EdgeInsets.all(13),
                    child: Center(
                      child: _mainChart(),
                    )));
  }
}
