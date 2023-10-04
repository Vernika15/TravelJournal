import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import './textstyle_widget.dart';

class TextFieldWidget extends StatefulWidget {
  final String hintText;
  final IconData prefixImage;
  final bool isPasswordType;
  final TextEditingController controller;
  bool passwordVisible = false;
  final String subText;
  final VoidCallback? onTap;
  bool? enabled = true;

  TextFieldWidget({
    super.key,
    required this.hintText,
    required this.prefixImage,
    required this.isPasswordType,
    required this.controller,
    required this.passwordVisible,
    required this.subText,
    this.onTap,
    this.enabled,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.subText,
          textAlign: TextAlign.left,
          style: textStyle(
            color: kAppThemeColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: widget.controller,
          keyboardType: widget.isPasswordType
              ? TextInputType.visiblePassword
              : TextInputType.emailAddress,
          obscureText: widget.passwordVisible,
          enabled: widget.enabled,
          cursorColor: kAppThemeColor,
          style: TextStyle(color: kAppThemeColor.withOpacity(0.9)),
          onTap: widget.onTap,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(color: kAppThemeColor.withOpacity(0.9)),
            prefixIcon: Icon(widget.prefixImage,
                color: kAppThemeColor.withOpacity(0.9)),
            suffixIcon: widget.isPasswordType
                ? IconButton(
                    icon: Icon(
                        !widget.passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: kAppThemeColor.withOpacity(0.9)),
                    onPressed: () {
                      // Update the state i.e. toggle the state of passwordVisible variable
                      setState(() {
                        widget.passwordVisible = !widget.passwordVisible;
                      });
                    },
                  )
                : null,
            filled: true,
            fillColor: kAppThemeColor.withOpacity(0.3),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11.0),
              borderSide: const BorderSide(
                color: kAppThemeColor,
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11.0),
              borderSide: const BorderSide(
                color: kAppThemeColor,
                width: 0,
                style: BorderStyle.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
