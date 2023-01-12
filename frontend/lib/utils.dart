import 'package:ac/colors.dart';
import 'package:flutter/material.dart';

enum TimePeriod {
  Hour,
  Day,
  Month,
  Year,
}

extension TimePeriodExtension on TimePeriod {
  String get name {
    switch (this) {
      case TimePeriod.Hour:
        return "Hour";
      case TimePeriod.Day:
        return "Day";
      case TimePeriod.Month:
        return "Month";
      case TimePeriod.Year:
        return "Year";
    }
  }

  String get dateFormat {
    switch (this) {
      case TimePeriod.Hour:
        return "hh:mm";
      case TimePeriod.Day:
        return "HH:mm";
      case TimePeriod.Month:
        return "MMMd";
      case TimePeriod.Year:
        return "MMM";
    }
  }

  double get interval {
    switch (this) {
      case TimePeriod.Hour:
        return Duration(minutes: 15).inMilliseconds.toDouble();
      case TimePeriod.Day:
        return Duration(hours: 5).inMilliseconds.toDouble();
      case TimePeriod.Month:
        return Duration(days: 7).inMilliseconds.toDouble();
      case TimePeriod.Year:
        return Duration(days: 60).inMilliseconds.toDouble();
    }
  }

  Duration get duration {
    switch (this) {
      case TimePeriod.Hour:
        return Duration(hours: 1);
      case TimePeriod.Day:
        return Duration(days: 1);
      case TimePeriod.Month:
        return Duration(days: 30);
      case TimePeriod.Year:
        return Duration(days: 365);
    }
  }
}

class TextStyles {
  static final TextStyle base = TextStyle(color: colors.main.text);

  static final TextStyle title = TextStyle(
      fontSize: 26, color: colors.main.text, fontWeight: FontWeight.bold);
  static final TextStyle title2 = TextStyle(
      fontSize: 24, color: colors.main.text, fontWeight: FontWeight.bold);
  static final TextStyle subtitle = TextStyle(
    fontSize: 16,
    color: colors.main.subtext0,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle chip = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle main1 = TextStyle(
    fontSize: 21,
    color: colors.main.subtext1,
    fontWeight: FontWeight.w400,
  );
}
