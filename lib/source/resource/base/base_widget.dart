import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'base_viewmodel.dart';

class BaseWidget<T extends BaseViewModel> extends StatefulWidget {
  final Widget Function(BuildContext context, T viewModel, Widget child) builder;
  final Function(T viewModel) onViewModelReady;
  final T viewModel;

  BaseWidget({
    Key key,
    @required this.viewModel,
    @required this.onViewModelReady,
    @required this.builder,
  }) : super(key: key);

  _BaseWidgetState<T> createState() => _BaseWidgetState<T>();
}

class _BaseWidgetState<T extends BaseViewModel> extends State<BaseWidget<T>> {
  T viewModel;

  @override
  void initState() {
    viewModel = widget.viewModel;
    widget.onViewModelReady(viewModel);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (context) => viewModel..setContext(context),
      child: Consumer<T>(
        builder: widget.builder,
      ),
    );
  }
}
