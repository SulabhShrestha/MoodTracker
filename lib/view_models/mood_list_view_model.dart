import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:mood_tracker/services/mood_web_services.dart';
import 'package:mood_tracker/view_models/mood_view_model.dart';

class MoodListViewModel extends ChangeNotifier {
  final _moodWebServices = MoodWebServices();

  Map<String, List<MoodViewModel>> moods = {};

  Stream<QuerySnapshot<Map<String, dynamic>>> get moodsStream =>
      _moodWebServices.moodsStream;

  Future<void> addNewMoodDB(
      {required int rating,
      required int timestamp,
      String? why,
      String? feedback}) async {
    await _moodWebServices.addNewMood(
        rating: rating, timestamp: timestamp, why: why, feedback: feedback);
  }

  Future<void> deleteMood(
      {required int timestamp, required String date}) async {
    //TODO: It's not working
    moods[date]?.removeWhere((element) {
      log("Timestamp: ${element.timestamp.timestamp}");
      return element.timestamp.timestamp == timestamp;
    });

    // removing entries if it had no value
    if (moods[date]!.isEmpty) {
      moods.remove(date);
    }

    _moodWebServices.deleteMood(timestamp: timestamp);

    notifyListeners();
  }

  Future<void> updateMoodDB(
      {required int rating,
      required int timestamp,
      required String date,
      String? why,
      String? feedback}) async {
    await _moodWebServices.updateMood(
        timestamp: timestamp,
        rating: rating,
        date: date,
        feedback: feedback,
        why: why);
  }
}
