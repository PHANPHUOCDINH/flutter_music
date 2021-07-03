import 'package:flutter/material.dart';

import '../../source.dart';

class WidgetStar extends StatelessWidget {
  final int star;

  WidgetStar({this.star});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 3,
      children: List.generate(
        star,
        (index) => Icon(
          Icons.star,
          size: 14,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
