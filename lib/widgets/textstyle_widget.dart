import 'package:flutter/material.dart';

TextStyle textStyle({
  Color color = Colors.black,
  FontWeight fontWeight = FontWeight.normal,
  double fontSize = 14,
}) {
  return TextStyle(
    fontSize: fontSize,
    color: color,
    fontWeight: fontWeight,
  );
}
