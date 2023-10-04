import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String buttonText1;
  final Function onButtonText1Pressed;
  final String buttonText2;
  final Function? onButtonText2Pressed;

  CustomAlertDialog({
    required this.title,
    required this.content,
    required this.buttonText1,
    required this.onButtonText1Pressed,
    this.buttonText2 = '',
    this.onButtonText2Pressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        if (buttonText2.isNotEmpty && onButtonText2Pressed != null)
          TextButton(
            onPressed: () {
              onButtonText2Pressed!();
              Navigator.of(context).pop();
            },
            child: Text(buttonText2),
          ),
        TextButton(
          onPressed: () {
            onButtonText1Pressed();
            Navigator.of(context).pop();
          },
          child: Text(buttonText1),
        ),
      ],
    );
  }
}
