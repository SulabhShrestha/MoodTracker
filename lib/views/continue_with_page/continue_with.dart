import 'package:flutter/material.dart';
import 'package:mood_tracker/view_models/auth_view_model.dart';

import '../core/button.dart';

/// Displays only app icon and continue with google button
class ContinueWithPage extends StatelessWidget {
  const ContinueWithPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Placeholder(),
                Button(
                    child: const Text("Continue with Google"),
                    onTap: () async {
                      await AuthViewModel().signInWithGoogle();
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
