import 'package:ac/colors.dart';
import 'package:flutter/material.dart';

enum TimePeriod {
  Day,
  Week,
  Month,
  Year,
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
