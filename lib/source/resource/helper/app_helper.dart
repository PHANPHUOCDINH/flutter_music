import 'package:intl/intl.dart';

class AppHelper {
  AppHelper._();

  static final formatter = new NumberFormat("#,###");

  static String convertNumber(int amount) {
    return formatter.format(amount);
  }

  static String minimum(int value) {
    if (value == null) return "00";
    return value < 10 ? "0$value" : "$value";
  }

  static String convertPhoneNumber(String phoneNumber) {
    if (phoneNumber.startsWith("+84")) return phoneNumber;
    return phoneNumber.replaceFirst("0", "+84");
  }

  static String convertGmail(String gmail, {String hide = "*****"}) {
    RegExp regex = new RegExp(r"(?=@).+(?=$)");
    String result;

    result = regex
        .allMatches(gmail)
        .map((e) => e.group(0))
        .toString()
        .replaceAll("(", "")
        .replaceAll(")", "");
    if (!regex.hasMatch(gmail)) gmail.replaceAll(regex, "");
    gmail = gmail.replaceRange(3, gmail.length, hide);
    return "$gmail$result";
  }

  static Map<String, dynamic> mapData(Map<String, dynamic> data) {
    return {"data": data};
  }

  static Map<String, dynamic> parseData(Map<String, dynamic> data) {
    return data['data'] ?? {};
  }

  static String convertDurationToTime(int duration) {
    var minute = duration ~/ 60;
    return "$minute:${duration - (60 * minute)}";
  }

  static String convertDurationToTime2(Duration duration) {
    return "${duration.inMinutes}:${duration.inSeconds}";
  }

  static double convertDurationToNumber(Duration duration) {
    var total =
        duration.inHours * 60 + duration.inMinutes * 60 + duration.inSeconds;
    return total / 30;
  }
}
