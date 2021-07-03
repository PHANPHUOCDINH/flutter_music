import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WidgetShimmer extends StatelessWidget {
  final Widget child;

  final Color baseColor;
  final Color highLightColor;

  const WidgetShimmer({
    @required this.child,
    this.baseColor = Colors.black26,
    this.highLightColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: child,
      baseColor: baseColor,
      highlightColor: highLightColor,
      enabled: true,
    );
  }
}
