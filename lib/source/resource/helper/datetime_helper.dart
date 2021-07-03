import 'package:intl/intl.dart';

class DateTimeHelper {
  static String convertDateTime2String(
    DateTime dateTime, {
    String format = 'dd/MM/yyyy',
  }) {
    if (dateTime == null) return "";
    return DateFormat(format).format(dateTime);
  }

  static DateTime convertString2DateTime(
    String dateTime, {
    String format = "yyyy-MM-ddTHH:mm:ss.SSSZ",
  }) {
    if (dateTime == null) return null;
    return DateFormat(format).parse(dateTime);
  }

  static String convertString2String(
    String dateTime, {
    String inputFormat = "yyyy-MM-ddTHH:mm:ss.SSSZ",
    String outputFormat = "yyyy-MM-dd",
  }) {
    if (dateTime == null) return "";
    final input = convertString2DateTime(dateTime, format: inputFormat);
    return convertDateTime2String(input, format: outputFormat);
  }
}
