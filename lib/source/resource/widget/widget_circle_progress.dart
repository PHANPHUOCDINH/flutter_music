import 'package:flutter/material.dart';

import '../../source.dart';

class WidgetCircleProgress extends StatelessWidget {
  final double value;

  final Color valueColor;
  final Color backgroundColor;

  const WidgetCircleProgress({
    this.value,
    this.valueColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      padding: const EdgeInsets.all(5),
      child: CircularProgressIndicator(
        value: value,
        strokeWidth: 4.5,
        valueColor: AlwaysStoppedAnimation(valueColor ?? AppColors.primary),
        backgroundColor: backgroundColor ?? AppColors.primary.withOpacity(0.25),
      ),
    );
  }
}
