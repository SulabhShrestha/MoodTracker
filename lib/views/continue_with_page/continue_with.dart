import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mood_tracker/view_models/auth_view_model.dart';
import 'package:mood_tracker/view_models/local_storage_view_model.dart';

import '../core/button.dart';

/// Displays only app icon and continue with google button
class ContinueWithPage extends StatefulWidget {
  const ContinueWithPage({Key? key}) : super(key: key);

  @override
  State<ContinueWithPage> createState() => _ContinueWithPageState();
}

class _ContinueWithPageState extends State<ContinueWithPage> {

  bool isLoading = false;
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
                  child: isLoading? const CircularProgressIndicator() : const Text("Continue with Google"),
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await LocalStorageViewModel().setIsAppLaunchedFirstTime();
                    await AuthViewModel().signInWithGoogle().onError((error, stackTrace){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Signing in failed"),));
                    });
                    setState(() {
                      isLoading = false;
                    });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
