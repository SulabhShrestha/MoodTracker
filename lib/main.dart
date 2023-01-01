import 'package:flutter/material.dart';
import 'package:mood_tracker/views/sign_in/sign_in.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Mood Tracker',
      home: SignInPage(),
    );
  }
}
