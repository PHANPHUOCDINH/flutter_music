import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../source.dart';

class SplashViewModel extends BaseViewModel {
  init() async {
    setLoading(true);
    await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    ).then(
      (position) async {
        var placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.length > 0) {
          Data.city = placemarks[0].administrativeArea;
        }

        Data.location = position;
        Data.weatherVi = await getWeatherToday(
          lat: position.latitude,
          lon: position.longitude,
          lang: "vi",
        );

        Data.weatherEn = await getWeatherToday(
          lat: position.latitude,
          lon: position.longitude,
          lang: "en",
        );
      },
    ).catchError((e) => print(e));

    var data = await AppShared.getTracks();
    if (data != null) {
      Data.trackDownloads = TrackModel.listFromJson(jsonDecode(data));
    }

    AppFirebase.firebaseAuth.authStateChanges().listen((user) async {
      if (user == null) return;
      var doc =
          await AppFirebase.userCollection.doc("userID-${user.uid}").get();
      var data = doc.data();

      if (data != null) {
        Data.userModel = UserModel.fromJson(data);
      }
    });

    await Future.delayed(Duration(milliseconds: 750));
    Navigator.pushReplacementNamed(context, Routers.navigation);
    setLoading(false);
  }

  Future<WeatherModel> getWeatherToday({
    double lat,
    double lon,
    String lang,
  }) async {
    if (lat == null || lon == null) return null;
    Map<String, dynamic> params = {
      "lat": lat,
      "lon": lon,
      "appid": AppEndPoint.API_KEY,
      "lang": lang,
    };

    Response response = await AppClients(
      baseUrl: AppEndPoint.BASE_URL_2,
    ).get(
      AppEndPoint.GET_WEATHER,
      queryParameters: params,
    );

    return WeatherModel.fromJson(response.data);
  }
}
