class AppEndPoint {
  AppEndPoint._();

  static const String BASE_URL = "https://api.deezer.com/";
  static const String BASE_URL_2 = "https://api.openweathermap.org/";
  static const String API_KEY = "9102fbcf8a7c631b1383fd8739c797f8";

  static const int connectionTimeout = 15000;
  static const int receiveTimeout = 15000;
  static const String keyAuthorization = "Authorization";

  static const int SUCCESS = 200;
  static const int ERROR_TOKEN = 401;
  static const int ERROR_VALIDATE = 422;
  static const int ERROR_SERVER = 500;
  static const int ERROR_DISCONNECT = -1;

  // Đăng ký
  static const String REGISTER_PHONE = '/registryByEmail';

  // Đăng nhập
  static const String LOGIN_PHONE = "/loginnormal";
  static const String LOGIN_GOOGLE = "/loginbygoogle";
  static const String LOGIN_APPLE = "/loginbyapple";
  static const String LOGIN_FB = "/loginbyfacebook";

  // Search
  static const String GET_SEARCH = "/search";
  static const String GET_ALBUM = "/album";
  static const String GET_GENRE = "/genre";
  static const String GET_WEATHER = "/data/2.5/weather";
}
