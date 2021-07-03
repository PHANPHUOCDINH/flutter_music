import 'package:flutter/material.dart';

import '../source.dart';

class Routers {
  static const String album = "/album";
  static const String music = "/music";
  static const String navigation = "/navigation";
  static const String notification = "/notification";
  static const String search = "/search";
  static const String profile_update = "/profile_update";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    var arguments = settings.arguments;
    switch (settings.name) {
      case navigation:
        return scaleRoute(NavigationScreen());
      case music:
        return scaleRoute(MusicScreen(trackModel: arguments));
      case album:
        return scaleRoute(AlbumScreen(genreModel: arguments));
      case search:
        return scaleRoute(SearchScreen());
      case notification:
        return scaleRoute(NotificationScreen(keyword: arguments));
      case profile_update:
        return scaleRoute(ProfileUpdateScreen());
      default:
        return animRoute(
          Container(
            child: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  static Route animRoute(
    Widget page, {
    Offset beginOffset,
    String name,
    Object arguments,
  }) {
    return PageRouteBuilder(
      settings: RouteSettings(name: name, arguments: arguments),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = beginOffset ?? Offset(1.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  static Route scaleRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 150),
      pageBuilder: (context, animation, secondAnimation) => page,
      transitionsBuilder: (context, animation, secondAnimation, child) {
        return ScaleTransition(
          scale: animation,
          alignment: Alignment.center,
          child: child,
        );
      },
    );
  }
}
