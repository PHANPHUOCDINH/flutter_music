import 'package:flutter/material.dart';

class WidgetRestart extends StatefulWidget {
  final Widget child;

  WidgetRestart({@required this.child});

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_WidgetRestartState>().restartApp();
  }

  @override
  _WidgetRestartState createState() => _WidgetRestartState();
}

class _WidgetRestartState extends State<WidgetRestart> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() => key = UniqueKey());
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
