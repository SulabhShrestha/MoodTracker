import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/mood_stats.dart';

/// Return type Map<String, dynamic> which return data as well as size of the docs returned from db

class StatsWebServices {
  Future<Map<String, dynamic>> fetchAllTime() async {
    // Contains all rating moods stats
    // if rating = 1, it's index position is rating-1
    List<MoodStats> moodsStats = List.generate(5,
        (index) => MoodStats(occurrence: 0, rating: index + 1, percentage: 0));

    var firebaseData =
        await FirebaseFirestore.instance.collectionGroup('List').get();

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
      log("${elem.rating} ${elem.occurrence} ${elem.percentage}");
    }
    return {"data": moodsStats, "docsSize": firebaseData.docs.length};
  }

  Future<Map<String, dynamic>> fetchThisMonth() async {
    // Contains all rating moods stats
    // if rating = 1, it's index position is rating-1
    List<MoodStats> moodsStats = List.generate(5,
        (index) => MoodStats(occurrence: 0, rating: index + 1, percentage: 0));

    // getting timestamp of first day of this month
    DateTime now = DateTime.now();
    now = DateTime(now.year, now.month, now.day, 0, 0, 0); // 12:00 AM
    int currentDay = now.day;
    DateTime startOfMonth = now.subtract(Duration(days: currentDay - 1));
    int timestamp = startOfMonth.millisecondsSinceEpoch;

    var firebaseData = await FirebaseFirestore.instance
        .collectionGroup('List')
        .where("timestamp", isGreaterThanOrEqualTo: timestamp)
        .get();

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
    }
    return {"data": moodsStats, "docsSize": firebaseData.docs.length};
  }

  Future<Map<String, dynamic>> fetchThisWeek() async {
    // Contains all rating moods stats
    // if rating = 1, it's index position is rating-1
    List<MoodStats> moodsStats = List.generate(5,
        (index) => MoodStats(occurrence: 0, rating: index + 1, percentage: 0));

    // getting timestamp of first day of this week
    // TODO: first day of the week depends on the country
    DateTime now = DateTime.now();
    now = DateTime(now.year, now.month, now.day, 0, 0, 0);
    int currentDayOfWeek = now.weekday;
    DateTime startOfWeek = now.subtract(Duration(days: currentDayOfWeek));

    int timestamp = startOfWeek.millisecondsSinceEpoch;

    var firebaseData = await FirebaseFirestore.instance
        .collectionGroup('List')
        .where("timestamp", isGreaterThanOrEqualTo: timestamp)
        .get();

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
    }
    return {"data": moodsStats, "docsSize": firebaseData.docs.length};
  }

  Future<Map<String, dynamic>> fetchRange(
      {required var startTimestamp, required var endTimestamp}) async {
    // Contains all rating moods stats
    // if rating = 1, it's index position is rating-1
    List<MoodStats> moodsStats = List.generate(5,
        (index) => MoodStats(occurrence: 0, rating: index + 1, percentage: 0));

    var firebaseData = await FirebaseFirestore.instance
        .collectionGroup('List')
        .where("timestamp", isGreaterThanOrEqualTo: startTimestamp)
        .where("timestamp", isLessThanOrEqualTo: endTimestamp)
        .get();

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
    }
    return {"data": moodsStats, "docsSize": firebaseData.docs.length};
  }
}
