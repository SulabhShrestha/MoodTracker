import 'package:firebase_auth/firebase_auth.dart';

/// This web services handles everything related to user's settings
///

class UserWebServices {
  final _auth = FirebaseAuth.instance;
  Future<void> updateUserName(String name) async {
    await _auth.currentUser?.updateDisplayName(name);
  }

  String get getUserName {
    return _auth.currentUser!.displayName ?? "Invisible Character";
  }

  String? get getEmail {
    return _auth.currentUser?.email;
  }

  String get userProfileURL {
    return _auth.currentUser?.photoURL ??
        ""; // It won't affect in the building part as it will be checked before building
  }
}
