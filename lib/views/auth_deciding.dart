import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mood_tracker/views/root_page.dart';

import 'continue_with_page/continue_with.dart';

class AuthDeciding extends StatelessWidget {
  const AuthDeciding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          return const RootPage();
        }
        return const ContinueWithPage();
      },
    );
  }
}
