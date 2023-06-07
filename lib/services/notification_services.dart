import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mood_tracker/services/user_web_services.dart';
import 'package:mood_tracker/views/add_new_mood/add_new_mood.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initialize(GlobalKey<NavigatorState> navigatorKey) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) async {
          await navigatorKey.currentState?.push(
            MaterialPageRoute<void>(builder: (context) => const AddNewMood()),
          );
        });
  }

  Future<void> showNotification() async {
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      DateTime.now().millisecondsSinceEpoch.toString(),
      "Enter your mood today", // User-visible name of the channel
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    String username = UserWebServices().getUserName;
    await flutterLocalNotificationsPlugin.show(
      0,
      'Hi $username',
      'How are feeling today?',
      notificationDetails,
    );
  }




  Future<void> scheduleDailyNotification() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Get the current timezone
    final timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    // Calculate the next 6:00 PM from the current time
    final now = tz.TZDateTime.now(tz.local);
    final scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      15,
      15, // 6 PM
    );
    if (now.isAfter(scheduledTime)) {
      // If the current time is already past 6 PM, schedule it for the next day
      scheduledTime.add(const Duration(minutes: 1));
    }

    // Schedule the daily notification at 6 PM
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Daily Notification',
      'This is a daily notification',
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'ID',
          'How are feeling today?',
          channelDescription: 'your channel description',
        ),
      ),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'notification_payload',
      androidScheduleMode: AndroidScheduleMode.exact,
    );

    // Schedule the notification to display again after one minute
    final repeatTime = scheduledTime.add(const Duration(minutes: 1));
    await flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      'Repeated Notification',
      'This notification repeats after one minute',
      repeatTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'ID',
          'How are feeling today?',
          channelDescription: 'your channel description',
        ),
      ),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'notification_payload',
      androidScheduleMode: AndroidScheduleMode.exact,
    );
  }
}
