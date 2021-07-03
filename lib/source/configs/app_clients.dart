import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';

import '../source.dart';

class AppClients extends DioForNative {
  static const String GET = "GET";
  static const String POST = "POST";
  static const String PUT = "PUT";
  static const String DELETE = "DELETE";

  AppClients({
    String baseUrl = AppEndPoint.BASE_URL,
    BaseOptions options,
  }) : super(options) {
    this.interceptors.add(
          InterceptorsWrapper(
            onRequest: _requestInterceptor,
            onResponse: _responseInterceptor,
            onError: _errorInterceptor,
          ),
        );
    this.options.baseUrl = baseUrl;
  }

  _requestInterceptor(RequestOptions options) async {
    switch (options.method) {
      case AppClients.GET:
        print(
            "${options.method}: ${options.uri}\nParams: ${options.queryParameters}");
        break;
      case AppClients.POST:
        if (options.data is Map) {
          print("${options.method}: ${options.uri}\nParams: ${options.data}");
        } else if (options.data is FormData) {
          print(
              "${options.method}: ${options.uri}\nParams: ${options.data.fields}");
        }

        break;
    }

    options.connectTimeout = AppEndPoint.connectionTimeout;
    options.receiveTimeout = AppEndPoint.receiveTimeout;
    return options;
  }

  _responseInterceptor(Response response) {
    print(
        "Response ${response.request.uri}: ${response.statusCode}\nData: ${response.data}");
  }

  _errorInterceptor(DioError dioError) {
    print("Error ${dioError}");
  }
}
