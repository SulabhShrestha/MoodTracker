import 'package:firebase_auth/firebase_auth.dart';

/// This web services handles everything related to user's settings
///

class UserWebServices {
  Future<void> updateUserName(String name) async {
    await FirebaseAuth.instance.currentUser?.updateDisplayName(name);
  }

  String get getUserName {
    return FirebaseAuth.instance.currentUser!.displayName ??
        "Invisible Character";
  }
}
