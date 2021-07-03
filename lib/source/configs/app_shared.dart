import 'dart:async';
import 'dart:convert';

import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../source.dart';

class AppShared {
  AppShared._();

  static final _prefs = RxSharedPreferences(SharedPreferences.getInstance());

  static const String _keyAccessToken = "keyAccessToken";
  static const String _keyFirebaseToken = "keyFirebaseToken";
  static const String _keyUser = "keyUser";
  static const String _keyTrackDownload = "keyTrackDownload";
  static const String _keyListenTrackNotification =
      "keyListenTrackNotification";

  static Future<bool> setAccessToken(String token) => _prefs.setString(
        _keyAccessToken,
        token,
      );

  static Future<String> getAccessToken() => _prefs.getString(_keyAccessToken);

  static Future<bool> setFirebaseToken(String token) => _prefs.setString(
        _keyFirebaseToken,
        token,
      );

  static Future<String> getFirebaseToken() =>
      _prefs.getString(_keyFirebaseToken);

  static Future<bool> setListenTrackNotification(bool enable) => _prefs.setBool(
        _keyListenTrackNotification,
        enable,
      );

  static Future<bool> getListenTrackNotification() =>
      _prefs.getBool(_keyListenTrackNotification);

  static Stream<bool> watchListenTrackNotification() {
    return _prefs.getBoolStream(_keyListenTrackNotification).transform(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) =>
                data == null ? sink.add(false) : sink.add(data),
          ),
        );
  }

  static Future<bool> setUser(UserModel data) async {
    String json = data != null ? jsonEncode(data) : "";
    return _prefs.setString(_keyUser, json);
  }

  static Future<UserModel> getUser() async {
    String user = await _prefs.getString(_keyUser);
    print("User: $user");

    if (user != null && user.length != 0) {
      return UserModel.fromJson(jsonDecode(user));
    } else {
      return null;
    }
  }

  static Future<bool> setTracks(String tracks) => _prefs.setString(
        _keyTrackDownload,
        tracks,
      );

  static Future<String> getTracks() => _prefs.getString(_keyTrackDownload);

  static Stream<List<TrackModel>> watchTracks() {
    return _prefs.getStringStream(_keyTrackDownload).transform(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) => (data == null || data.length == 0)
                ? sink.add([])
                : sink.add(TrackModel.listFromJson(data)),
          ),
        );
  }

  static Stream<UserModel> watchUser() {
    return _prefs.getStringStream(_keyUser).transform(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) => (data == null || data.length == 0)
                ? sink.add(null)
                : sink.add(
                    UserModel.fromJson(jsonDecode(data)),
                  ),
          ),
        );
  }
}
