import 'package:flutter/material.dart';

import '../../source.dart';

class WidgetButtonGradientAnimation extends StatefulWidget {
  final String title;

  final double height;
  final double width;

  final bool isLoading;

  final Color colorStart;
  final Color colorEnd;
  final Color colorLoading;
  final Color colorBorder;

  final Alignment alignmentStart;
  final Alignment alignmentEnd;

  final Function action;
  final EdgeInsets padding;
  final TextStyle textStyle;

  const WidgetButtonGradientAnimation({
    @required this.title,
    this.height = 45,
    @required this.width,
    this.isLoading = false,
    @required this.colorStart,
    @required this.colorEnd,
    this.colorLoading = Colors.white,
    this.colorBorder,
    this.alignmentStart = Alignment.centerLeft,
    this.alignmentEnd = Alignment.centerRight,
    @required this.action,
    this.padding = const EdgeInsets.all(0),
    this.textStyle,
  });

  @override
  _WidgetButtonGradientAnimationState createState() =>
      _WidgetButtonGradientAnimationState();
}

class _WidgetButtonGradientAnimationState
    extends State<WidgetButtonGradientAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _sizeHeightAnimation;
  Animation<double> _sizeWidthAnimation;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    _sizeHeightAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween(
          begin: widget.height,
          end: widget.height * 1.2,
        ),
        weight: widget.height * 1.2,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: widget.height * 1.2,
          end: widget.height,
        ),
        weight: widget.height,
      ),
    ]).animate(_controller);

    _sizeWidthAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween(
          begin: widget.width,
          end: widget.width * 1.2,
        ),
        weight: widget.width * 1.2,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: widget.width * 1.2,
          end: widget.width,
        ),
        weight: widget.width,
      ),
    ]).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Container(
          height: _sizeHeightAnimation.value,
          width: _sizeWidthAnimation.value,
          child: child,
        );
      },
      child: RaisedButton(
        onPressed: widget.isLoading ?? false
            ? null
            : () {
                if (_controller.status == AnimationStatus.completed) {
                  _controller.reverse();
                } else if (_controller.status == AnimationStatus.dismissed) {
                  _controller.forward();
                  Future.delayed(
                    Duration(milliseconds: 200),
                    () => widget.action.call(),
                  );
                }
              },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(80.0),
        ),
        padding: const EdgeInsets.all(0.0),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.colorStart,
                widget.colorEnd,
              ],
              end: widget.alignmentStart,
              begin: widget.alignmentEnd,
            ),
            borderRadius: BorderRadius.circular(30.0),
            border: Border.all(
              color: widget.colorBorder ?? Colors.transparent,
              width: 1,
            ),
          ),
          child: Container(
            padding: widget.padding,
            alignment: Alignment.center,
            child: !widget.isLoading
                ? Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: widget.textStyle ??
                        AppStyles.DEFAULT_REGULAR.copyWith(
                          color: Colors.white,
                        ),
                  )
                : Center(
                    child: WidgetLoading(
                      dotOneColor: widget.colorLoading,
                      dotTwoColor: widget.colorLoading,
                      dotThreeColor: widget.colorLoading,
                      dotType: DotType.circle,
                      duration: Duration(milliseconds: 1000),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
