import 'package:flutter/material.dart';

import '../../source.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      viewModel: SplashViewModel(),
      onViewModelReady: (vm) => _viewModel = vm..init(),
      builder: (context, vm, child) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: _buildBody(),
        );
      },
    );
  }

  Widget _buildBody() {
    return Center(
      child: Text(
        "Welcome to spotify clone :3 :3",
        style: AppStyles.DEFAULT_2XLARGE.copyWith(
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
