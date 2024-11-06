import 'package:flutter/material.dart';
import 'package:goodali/utils/colors.dart';

extension GeneralTextStyle on TextTheme {
  static TextStyle bodyText({
    Color? textColor = GeneralColors.textColor,
    double fontSize = 12,
    double? height,
    FontWeight fontWeight = FontWeight.w400,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      color: textColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      decoration: decoration,
      height: height,
    );
  }

  static TextStyle titleText({
    Color? textColor,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w700,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      color: textColor ?? GeneralColors.textColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      decoration: decoration,
    );
  }
}
