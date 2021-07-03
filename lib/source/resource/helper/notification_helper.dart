import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationHelper {
  static FlutterLocalNotificationsPlugin _localNotification;
  static AndroidInitializationSettings _androidSetting;
  static IOSInitializationSettings _iosSetting;
  static InitializationSettings _initSetting;
  static AndroidNotificationDetails _androidNotificationDetails;
  static IOSNotificationDetails _iosNotificationDetails;
  static NotificationDetails _notificationDetails;

  static void initNotificationManager({
    Function(String payload) onSelectNotification,
  }) {
    _androidSetting = new AndroidInitializationSettings('@mipmap/ic_launcher');
    _iosSetting = new IOSInitializationSettings();
    _initSetting = new InitializationSettings(
      android: _androidSetting,
      iOS: _iosSetting,
    );

    _androidNotificationDetails = AndroidNotificationDetails(
      'channel id',
      'channel name',
      'channel description',
      importance: Importance.max,
      priority: Priority.high,
    );

    _iosNotificationDetails = new IOSNotificationDetails();
    _notificationDetails = new NotificationDetails(
      android: _androidNotificationDetails,
      iOS: _iosNotificationDetails,
    );

    _localNotification = new FlutterLocalNotificationsPlugin();
    _localNotification.initialize(
      _initSetting,
      onSelectNotification: onSelectNotification,
    );

    tz.initializeTimeZones();
  }

  static Future<void> showNotification({
    @required DateTime dt,
    @required String title,
    @required String body,
  }) async {
    await _localNotification.zonedSchedule(
      0,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(Duration(milliseconds: 250)),
      _notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelNotification(int id) async {
    await _localNotification.cancel(id);
  }

  static tz.TZDateTime _instanceOfScheduleTime() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);

    if (scheduledDate.isBefore(now))
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    return scheduledDate;
  }
}
