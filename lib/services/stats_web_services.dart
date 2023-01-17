import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/mood_stats.dart';

class StatsWebServices {
  Future<List<MoodStats>> fetchAllTime() async {
    // Contains all rating moods stats
    // if rating = 1, it's index position is rating-1
    List<MoodStats> moodsStats = List.generate(5,
        (index) => MoodStats(occurrence: 0, rating: index + 1, percentage: 0));

    var firebaseData =
        await FirebaseFirestore.instance.collection('Mood').get();

    int totalOccurrence = 0;

    for (var element in firebaseData.docs) {
      var rating = element.get("rating");
      totalOccurrence++;

      moodsStats[rating - 1]
          .occurrence++; // Increasing occurrence by one on each loop

    }

    // for adding percentage
    for (var elem in moodsStats) {
      elem.percentage = (elem.occurrence / totalOccurrence) * 100;
      log("ELEMENT: ${elem.percentage} ${elem.occurrence} ${elem.rating}");
    }
    return moodsStats;
  }
}
