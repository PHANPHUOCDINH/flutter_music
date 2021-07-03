import 'package:dio/dio.dart';

import '../source.dart';

enum LoginType { apple, facebook, google, phone, normal }
enum RequestType { Get, Post }

class AuthenticationRepository {
  AuthenticationRepository._();

  static AuthenticationRepository _instance;

  factory AuthenticationRepository() =>
      _instance ?? AuthenticationRepository._();

  Future<NetworkState<List<TrackModel>>> getSearch({String keyword}) async {
    bool isDisconnect = await WifiHelper.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();

    try {
      Map<String, dynamic> params = {"q": keyword};
      Response response = await AppClients().get(
        AppEndPoint.GET_SEARCH,
        queryParameters: params,
      );

      return NetworkState(
        status: response.statusCode,
        response: NetworkResponse.fromJson(
          response.data,
          converter: (json) => TrackModel.listFromJson(json),
        ),
      );
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }
}
