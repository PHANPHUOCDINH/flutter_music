import 'package:flutter/material.dart';

class NetworkResponse<T> {
  int status;

  T data;

  NetworkResponse({
    @required this.status,
    @required this.data,
  });

  NetworkResponse.fromJson(dynamic json, {converter}) {
    status = json["status"];
    data = converter != null && json["data"] != null ? converter(json["data"]) : json["data"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    map["data"] = data;
    return map;
  }
}
