import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mood_tracker/services/mood_web_services.dart';

/// This web services handles everything related to user's settings
///

class UserWebServices {
  final _auth = FirebaseAuth.instance;
  Future<void> updateUserName(String name) async {
    await _auth.currentUser?.updateDisplayName(name);
  }

  String get getUserName {
    // name is never empty as it is from google auth
    return _auth.currentUser!.displayName!;
  }

  String get firstLetters {
    var fullName = _auth.currentUser!.displayName!;
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

  Future<void> _reauthenticateUser() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    await _auth.currentUser?.reauthenticateWithCredential(credential);
  }


  /// deletes the current user and all the data associated with it
  Future<void> deleteUser() async {
    await _reauthenticateUser();
    await deleteUserData();
    await _auth.currentUser!.delete();
    await _auth.signOut();
  }

  Future<void> deleteUserData() async {
    try{
      FirebaseFirestore.instance
          .collectionGroup('List')
          .where('userID', isEqualTo: _auth.currentUser!.uid)
          .get()
          .then(
            (querySnapshot) async{
          for (var doc in querySnapshot.docs) {

            // Deleting images first from the firestore storage
            List<dynamic> imagesPathD = doc.get("imagesPath");
            List<String> imagesPath = imagesPathD.map((e) => e.toString()).toList();

            await MoodWebServices().deleteImages(deletingImagePaths: imagesPath, date: doc.get("date"), timestamp: doc.get("timestamp"));

            // deleting the whole document
            doc.reference.delete();
          }
        },
      );
    }

    catch(e){
      rethrow;
    }

  }
}
