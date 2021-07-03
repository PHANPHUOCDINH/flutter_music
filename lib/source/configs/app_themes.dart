import 'package:flutter/material.dart';

import '../source.dart';

normalTheme(BuildContext context) {
  return ThemeData(
    fontFamily: AppStyles.FONT_ROBOTO,
    primarySwatch: Colors.blue,
    primaryColor: Colors.white,
    accentColor: Colors.blue,
    disabledColor: Colors.grey,
    cardColor: Colors.white,
    canvasColor: Colors.white,
    brightness: Brightness.light,
    buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: ColorScheme.light(),
          buttonColor: Colors.blue,
          splashColor: Colors.white,
        ),
    appBarTheme: AppBarTheme(elevation: 0.0),
  );
}
