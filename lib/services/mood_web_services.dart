import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/mood.dart';

class MoodWebServices {
  var date;

  MoodWebServices() {
    // Getting today's date, however it's system date
    var today = DateTime.now();
    date = "${today.year}-${today.month}-${today.day}";
  }

  Future<void> addNewMood(
      {required int rating, String? why, String? feedback}) async {
    CollectionReference moodRef = FirebaseFirestore.instance.collection('Mood');

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

  Future<void> getAllMoods() async {
    // Date : List<>
    final Map<String, List<Object>> groupedData = {};
    String groupedKey;

    FirebaseFirestore.instance
        .collection('Mood')
        .orderBy("timestamp")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        Object? ob = doc.data();

        groupedKey = doc.get("date");

        // This means that the current date mood is more than once
        if (groupedData.containsKey(groupedKey)) {
          groupedData[groupedKey]?.add(ob!);
        } else {
          groupedData[groupedKey] = [ob!];
        }
      }
    });
  }

  Future<List<Mood>> getAllMoodInSingle() async {
    List<Mood> moods = [];

    var firebaseData = await FirebaseFirestore.instance
        .collection('Mood')
        .orderBy("timestamp")
        .get();

    for (var element in firebaseData.docs) {
      // First converting to json, and decoding to json
      // Maybe in the future, db will be placed and instead of Object?, actual JSON be returned
      final Map<String, dynamic> json = jsonDecode(jsonEncode(element.data()));

      moods.add(Mood.fromJSON(json));
    }

    return moods;
  }
}
