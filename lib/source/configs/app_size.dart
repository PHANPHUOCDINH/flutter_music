import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppSize {
  static MediaQueryData _mediaQueryData;
  static double _safeAreaHorizontal;
  static double _safeAreaVertical;
  static double _blockSizeHorizontal;
  static double _blockSizeVertical;

  static double screenWidth;
  static double screenHeight;
  static double screenLeft;
  static double screenRight;

  static double safeBlockHorizontal;
  static double safeBlockVertical;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenLeft = _mediaQueryData.size.width / 100;
    screenRight = _mediaQueryData.size.width / 100;
    screenHeight = _mediaQueryData.size.height;

    _blockSizeHorizontal = screenWidth / 100;
    _blockSizeVertical = screenHeight / 100;

    _safeAreaHorizontal = _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical = _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;

    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
  }
}
