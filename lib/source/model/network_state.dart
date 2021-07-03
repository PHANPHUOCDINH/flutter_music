import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../source.dart';

class NetworkState<T> {
  String message;

  int status;

  NetworkResponse<T> response;

  NetworkState({
    this.message,
    @required this.response,
    @required this.status,
  });

  NetworkState.withError(DioError error) {
    String message;
    int code;

    print("=========== ERROR ===========");
    print("${error.type}");

    Response response = error.response;
    if (response != null) {
      print("=========== statusCode ===========");
      print("${response.statusCode}");
      code = response.statusCode;

      print("=========== data ===========");
      print("${response.data.toString()}");
      message = response.data["code"];
    } else {
      code = AppEndPoint.ERROR_SERVER;
      print("=========== message ===========");
      print("${error.message}");
      message = "Không thể kết nối đến máy chủ!";
    }

    this.message = message;
    this.status = code;
    this.response = null;
  }

  NetworkState.withDisconnect() {
    print("=========== DISCONNECT ===========");
    this.message = "Mất kết nối internet, vui lòng kiểm tra wifi/3g và thử lại!";
    this.status = AppEndPoint.ERROR_DISCONNECT;
    this.response = null;
  }

  T get data => response.data;

  bool get isSuccess => status == AppEndPoint.SUCCESS;

  bool get isError => status != AppEndPoint.SUCCESS;
}
