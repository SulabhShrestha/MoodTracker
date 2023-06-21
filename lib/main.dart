import 'dart:developer';
import 'dart:ui';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mood_tracker/services/notification_services.dart';
import 'package:mood_tracker/views/auth_deciding.dart';
import 'package:workmanager/workmanager.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) async {
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
    );
  });
  final navigatorKey = GlobalKey<NavigatorState>();

  await NotificationService().initialize(navigatorKey);

  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );


  runApp(MyApp(navigatorKey: navigatorKey));
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {

    log("Native called background task: $task");
    // Handle the background task here
    if (task == "notificationTask") {

      final now = DateTime.now();
      if (now.hour == 18 && now.minute == 0) {
        log("Showing notification");
        await NotificationService().showNotification();
      }
    }
    return Future.value(true);
  });
}

class MyApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const MyApp({Key? key, required this.navigatorKey}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    Workmanager().registerPeriodicTask(
      "notificationTask",
      "notificationTask",
      frequency: const Duration(days: 1), // Interval between subsequent executions
    );
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: widget.navigatorKey,
      title: 'Mood Tracker',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: window.locales,
      home: const AuthDeciding(),
    );
  }
}
