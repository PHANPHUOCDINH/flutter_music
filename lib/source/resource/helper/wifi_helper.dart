import 'dart:async';

import 'package:connectivity/connectivity.dart';

typedef WifiListener = Function(bool enabled);

class WifiHelper {
  StreamSubscription<ConnectivityResult> _subscription;

  WifiHelper({WifiListener listener}) {
    if (_subscription != null) _subscription.cancel();
    _subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (listener != null) listener(result != ConnectivityResult.none);
    });
  }

  static Future<bool> isConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  static Future<bool> isDisconnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.none;
  }

  close() => _subscription.cancel();
}
