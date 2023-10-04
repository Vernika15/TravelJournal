import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import './text_widget.dart';

class ButtonWidget extends StatelessWidget {
  final String buttonText;
  final Function onTap;

  ButtonWidget({
    super.key,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        child: TextWidget(
          text: buttonText,
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: whiteColor,
        ),
        onPressed: () {
          onTap();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: kAppThemeColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
        ),
      ),
    );
  }
}
