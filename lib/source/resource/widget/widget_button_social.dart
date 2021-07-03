import 'package:flutter/material.dart';

class WidgetButtonSocial extends StatelessWidget {
  final String imageUrl;

  final double size;

  final bool isLoading;

  final Function onTap;

  const WidgetButtonSocial({
    @required this.imageUrl,
    this.size = 48,
    this.isLoading = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? () {} : onTap,
      child: Image.asset(
        imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
