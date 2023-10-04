import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mood_tracker/view_models/auth_view_model.dart';
import 'package:mood_tracker/view_models/local_storage_view_model.dart';

import '../core/button.dart';

/// Displays only app icon and continue with google button
class ContinueWithPage extends StatelessWidget {
  const ContinueWithPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log("Inside of continue with page");
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/logo.png",
                  height: MediaQuery.of(context).size.height * 0.3),
              Button(
                  child: const Text("Continue with Google"),
                  onTap: () async {
                    await LocalStorageViewModel().setIsAppLaunchedFirstTime();
                    await AuthViewModel().signInWithGoogle();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
