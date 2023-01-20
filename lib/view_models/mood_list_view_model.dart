import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:mood_tracker/services/mood_web_services.dart';
import 'package:mood_tracker/view_models/mood_view_model.dart';

import '../models/mood.dart';

class MoodListViewModel extends ChangeNotifier {
  final _moodWebServices = MoodWebServices();

  Map<String, List<MoodViewModel>> moods = {};

  Future<void> addNewMoodDB(
      {required int rating,
      required int timestamp,
      String? why,
      String? feedback}) async {
    await _moodWebServices.addNewMood(
        rating: rating, timestamp: timestamp, why: why, feedback: feedback);
  }

  /// This adds new mood to [moods]
  Future<void> addNewMoodLocal(
      {required int rating,
      required int timestamp,
      String? why,
      String? feedback}) async {
    var now = DateTime.now();
    var todayDate = "${now.year}-${now.month}-${now.day}";

    // Adding to top of moods
    Map<String, dynamic> json = {
      "rating": rating,
      "why": why,
      "feedback": feedback,
      "date": todayDate,
      "timestamp": timestamp,
    };
    Mood mood = Mood.fromJSON(json);

    // This means that the current date mood is more than once
    if (moods.containsKey(todayDate)) {
      log("I am already");
      moods[todayDate]?.insert(0, MoodViewModel(mood: mood));
    } else {
      // Emptying the moods, so the latest one is at top
      var dummyMap = moods;
      moods = {};

      dummyMap[todayDate] = [MoodViewModel(mood: mood)];
      moods.addAll(dummyMap);
    }

    notifyListeners();
  }

  Future<void> fetchAllMoods() async {
    Map<String, List<Mood>> res = await _moodWebServices.getAllMoodsString();

    for (var element in res.entries) {
      List<MoodViewModel> list = [];

      for (var mood in element.value) {
        list.add(MoodViewModel(mood: mood));
      }

      moods[element.key] = list;
    }
    notifyListeners();
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
}
