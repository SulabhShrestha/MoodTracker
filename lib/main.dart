import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker/views/auth_deciding.dart';

import 'firebase_options.dart';
import 'utils/constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) async {
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
    );
  });

  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Tracker',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: WidgetsBinding.instance.platformDispatcher.locales,
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Constant().colors.blue,
          elevation: 0,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Constant().colors.blue,
          shape: CircleBorder(
            side: BorderSide(color: Constant().colors.primary),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                side: BorderSide(color: Constant().colors.primary),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            textStyle: MaterialStateProperty.all(
              const TextStyle(fontSize: 16),
            ),
            foregroundColor: MaterialStateProperty.all(
              Constant().colors.white,
            ),
            backgroundColor:
                MaterialStateProperty.all(Constant().colors.darkRed),
          ),
        ),
        listTileTheme: ListTileThemeData(
          iconColor: Constant().colors.primary,
        ),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              CircleBorder(
                side: BorderSide(color: Constant().colors.primary),
              ),
            ),
            padding: MaterialStateProperty.all(
              const EdgeInsets.all(8),
            ),
            iconColor: MaterialStateProperty.all(Constant().colors.primary),
            backgroundColor: MaterialStateProperty.all(Constant().colors.green),
          ),
        ),
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Constant().colors.primary),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        popupMenuTheme: PopupMenuThemeData(
          color: Constant().colors.blue,
          labelTextStyle: MaterialStateProperty.all(
            TextStyle(color: Constant().colors.primary, fontSize: 17),
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Constant().colors.primary),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      home: const AuthDeciding(),
    );
  }
}
