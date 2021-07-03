import 'package:flutter/material.dart';

import '../../source.dart';

class WidgetLogo extends StatelessWidget {
  final double width;
  final double height;

  WidgetLogo({
    this.width = 80,
    this.height = 35,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppImages.logo,
      width: width,
      height: height,
      fit: BoxFit.fill,
    );
  }
}
