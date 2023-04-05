import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mood_tracker/models/mood.dart';

class CalendarWebServices {
  /// Returns the first date from the entered moods
  Future<DateTime> getFirstEnteredMoodDateTime() async {
    final userID = FirebaseAuth.instance.currentUser!.uid;

    var firebaseData = await FirebaseFirestore.instance
        .collectionGroup('List')
        .where("userID", isEqualTo: userID)
        .get();

    var firstDate = firebaseData.docs.first.get("date");

    return DateTime.parse(firstDate);
  }

  /// Returns Map of having Datetime key and List of moods.
  Future<Map<DateTime, List<Mood>>> getAllMoodsDateTime() async {
    // Date : List<>
    final Map<DateTime, List<Mood>> groupedData = {};

    final userID = FirebaseAuth.instance.currentUser!.uid;

    var firebaseData = await FirebaseFirestore.instance
        .collectionGroup('List')
        .where("userID", isEqualTo: userID)
        .get();

    for (var element in firebaseData.docs) {
      // First converting to json, and decoding to json
      // Maybe in the future, db will be placed and instead of Object?, actual JSON be returned
      final Map<String, dynamic> json = jsonDecode(jsonEncode(element.data()));

      var res = element.get("date").split(" ").first.split("-"); // 1920-12-11

      DateTime dateTimeKey = DateTime.utc(
        int.parse(res[0]),
        int.parse(res[1]),
        int.parse(res[2]),
      );

      // This means that the current date mood is more than once
      if (groupedData.containsKey(dateTimeKey)) {
        groupedData[dateTimeKey]?.add(Mood.fromJSON(json));
      } else {
        groupedData[dateTimeKey] = [Mood.fromJSON(json)];
      }
    }

    return groupedData;
  }
}
