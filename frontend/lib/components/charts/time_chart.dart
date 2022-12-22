import 'package:ac/colors.dart';
import 'package:ac/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TempChart extends StatefulWidget {
  const TempChart({super.key, this.scope = TimePeriod.Day});

  final TimePeriod scope;

  @override
  State<TempChart> createState() => _TempChartState();
}

class _TempChartState extends State<TempChart> {
  final db = FirebaseFirestore.instance;
  List<FlSpot> data = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uuid = prefs.getString("uuid") ?? "";

    if (uuid.isEmpty) return;

    CollectionReference collection = db.collection(uuid);
    Query query = collection;

    // switch (widget.scope) {
    //   case TimePeriod.Day:
    //     query = collection.where("timestamp",
    //         isGreaterThan: DateTime.now().subtract(Duration(days: 1)));
    //     break;
    //   case TimePeriod.Week:
    //     query = collection.where("timestamp",
    //         isGreaterThan: DateTime.now().subtract(Duration(days: 7)));
    //     break;
    //   case TimePeriod.Month:
    //     query = collection.where("timestamp",
    //         isGreaterThan: DateTime.now().subtract(Duration(days: 30)));
    //     break;
    //   case TimePeriod.Year:
    //     query = collection.where("timestamp",
    //         isGreaterThan: DateTime.now().subtract(Duration(days: 365)));
    //     break;
    // }

    await query.get().then((value) {
      print(value.docs);
      for (var val in value.docs) {
        print(val.data());
      }
      // setState(() {
      //   data = value.docs
      //       .map((e) => FlSpot(
      //           (e.data() as Map)["timestamp"].millisecondsSinceEpoch,
      //           (e.data() as Map)["temperature"]))
      //       .toList();
      // });
    });
  }

  LineChartData _mainData() {
    return LineChartData(
      gridData: _gridData(),
      titlesData: FlTitlesData(
        show: true,
        leftTitles: AxisTitles(
          sideTitles: _yTitles(),
        ),
        bottomTitles: AxisTitles(
          sideTitles: _xTitles(),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: colors.highlight,
          width: 1,
        ),
      ),
      minX: data.first.x,
      maxX: data.last.x,
      minY: 0,
      maxY: 40,
      lineBarsData: [
        LineChartBarData(
          spots: data,
          isCurved: true,
          color: colors.highlight,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            color: colors.highlight.withOpacity(0.2),
          ),
        ),
      ],
    );
  }

  SideTitles _yTitles() {
    return SideTitles(
      showTitles: true,
      reservedSize: 30,
      interval: 5,
      getTitlesWidget: (value, meta) {
        return Text(
          "${value.toStringAsFixed(1)}°C",
          style: TextStyles.main1,
        );
      },
    );
  }

  SideTitles _xTitles() {
    return SideTitles(
      showTitles: true,
      reservedSize: 30,
      interval: 5,
      getTitlesWidget: (value, meta) {
        return Text(
          DateFormat("HH:mm")
              .format(DateTime.fromMillisecondsSinceEpoch(value.toInt())),
          style: TextStyles.main1,
        );
      },
    );
  }

  FlGridData _gridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: true,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: colors.highlight,
          strokeWidth: 1,
        );
      },
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: colors.highlight,
          strokeWidth: 1,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return (data.length > 0) ? Text("helol") : Text("hi");
  }
}
