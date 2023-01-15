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
      {required int rating,
      required int timestamp,
      String? why,
      String? feedback}) async {
    CollectionReference moodRef = FirebaseFirestore.instance.collection('Mood');

    await moodRef
        .add({
          'rating': rating,
          'why': why ?? "",
          'feedback': feedback ?? "",
          'timestamp': timestamp,
          'date': date,
        })
        .then((value) => log("Mood Added"))
        .catchError((error) => log("Failed to add user: $error"));
  }

  Future<Map<String, List<Mood>>> getAllMoods() async {
    // Date : List<>
    final Map<String, List<Mood>> groupedData = {};
    String groupedKey;

    var firebaseData = await FirebaseFirestore.instance
        .collection('Mood')
        .orderBy("timestamp", descending: true)
        .get();

    for (var element in firebaseData.docs) {
      // First converting to json, and decoding to json
      // Maybe in the future, db will be placed and instead of Object?, actual JSON be returned
      final Map<String, dynamic> json = jsonDecode(jsonEncode(element.data()));

      groupedKey = element.get("date");

      // This means that the current date mood is more than once
      if (groupedData.containsKey(groupedKey)) {
        groupedData[groupedKey]?.add(Mood.fromJSON(json));
      } else {
        groupedData[groupedKey] = [Mood.fromJSON(json)];
      }
    }

    return groupedData;
  }
}
