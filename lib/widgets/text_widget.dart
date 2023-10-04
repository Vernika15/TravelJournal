import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final Color color;
  final FontWeight fontWeight;
  final double fontSize;

  TextWidget({
    required this.text,
    this.textAlign = TextAlign.left,
    this.color = Colors.black,
    this.fontWeight = FontWeight.normal,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis, // Use ellipsis for overflow
      maxLines: 1, // Limit the number of lines to 1
      softWrap: false, // Disable line wrapping
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
