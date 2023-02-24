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

  String get firstLetters {
    var fullName = _auth.currentUser!.displayName ?? "Invisible Character";
    List<String> words = fullName.split(" ");
    String initials = "";

    for (String word in words) {
      initials += word.substring(0, 1);
    }
    return initials;
  }

  String get getEmail {
    return _auth.currentUser?.email ??
        ""; // email is never empty since it is log in using email
  }

  String get userProfileURL {
    return _auth.currentUser?.photoURL ??
        ""; // It won't affect in the building part as it will be checked before building
  }
}
