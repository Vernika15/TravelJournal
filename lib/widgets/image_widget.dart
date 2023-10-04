import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String imageName;
  final double width;
  final double height;

  ImageWidget({
    super.key,
    required this.imageName,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imageName,
      width: width,
      height: height,
      fit: BoxFit.fitWidth,
    );
  }
}
