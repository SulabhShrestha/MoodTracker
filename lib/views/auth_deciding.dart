import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mood_tracker/view_models/local_storage_view_model.dart';
import 'package:mood_tracker/views/onboarding_page/onboarding_page.dart';
import 'package:mood_tracker/views/root_page/root_page.dart';

import 'continue_with_page/continue_with.dart';

class AuthDeciding extends StatelessWidget {
  const AuthDeciding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: LocalStorageViewModel().isAppLaunchedFirstTime(),
      builder: (context, snapshot) {
        log("Data: ${snapshot.data}");
        return OnboardingPage();
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          // If app is launched first time, show onboarding page
          log("APP launched: ${snapshot.data}");
          if (snapshot.data!) {
            return OnboardingPage();
          } else {
            return StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return const RootPage();
                } else {
                  return const ContinueWithPage();
                }
              },
            );
          }
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
