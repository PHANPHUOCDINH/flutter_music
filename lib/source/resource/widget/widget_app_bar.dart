import 'package:flutter/material.dart';

import '../../source.dart';

class WidgetAppBar extends StatelessWidget {
  final String title;

  final double sizeLeading;
  final double height;

  final bool isBack;

  final Color colorButton;
  final Color colorTitle;
  final Color colorAppBar;

  final Alignment alignmentTitle;
  final EdgeInsets padding;
  final Widget children;
  final List<Widget> actions;

  final Function actionBack;

  const WidgetAppBar({
    @required this.title,
    this.sizeLeading = 18,
    this.height = 0,
    this.isBack = true,
    this.colorButton = Colors.black,
    this.colorTitle = Colors.white,
    this.colorAppBar,
    this.alignmentTitle = Alignment.center,
    this.padding = EdgeInsets.zero,
    this.children,
    this.actions,
    this.actionBack,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: AppSize.screenWidth,
        height: AppValues.HEIGHT_APP_BAR + height,
        color: colorAppBar ?? AppColors.primary,
        padding: padding,
        child: Column(
          children: [
            Row(
              children: [
                isBack
                    ? WidgetButtonBack(
                        action: actionBack,
                        size: sizeLeading,
                        color: colorButton,
                      )
                    : SizedBox(),
                Expanded(
                  child: Align(
                    alignment: alignmentTitle,
                    child: Text(
                      title,
                      style: AppStyles.DEFAULT_LARGE_BOLD.copyWith(
                        color: colorTitle ?? Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                actions == null
                    ? Opacity(
                        opacity: 0,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: colorButton,
                            size: sizeLeading,
                          ),
                          onPressed: () {},
                        ),
                      )
                    : Row(children: actions ?? []),
              ],
            ),
            children ?? Container(),
          ],
        ),
      ),
    );
  }
}

class WidgetButtonBack extends StatelessWidget {
  final Color color;
  final double size;
  final Function action;

  const WidgetButtonBack({
    this.color = Colors.grey,
    this.size = 18,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios_rounded,
        color: color,
        size: size,
      ),
      onPressed: action ?? () => Navigator.pop(context),
    );
  }
}
