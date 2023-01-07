import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class MoodWebServices {
  Future<void> add({required int rating, String? why, String? feedback}) async {
    CollectionReference moodRef = FirebaseFirestore.instance.collection('Mood');

    // Getting today's date, however it's system date
    var today = DateTime.now();
    var date = "${today.year}-${today.month}-${today.day}";

    await moodRef
        .add({
          'rating': rating,
          'why': why ?? "",
          'feedback': feedback ?? "",
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'date': date,
        })
        .then((value) => log("Mood Added"))
        .catchError((error) => log("Failed to add user: $error"));
  }
}
