import 'dart:async';

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
      String? why,
      String? feedback,
      required List<String?> imagesPath}) async {
    var timestamp = DateTime.now().millisecondsSinceEpoch;

    await _moodWebServices.addNewMood(
      rating: rating,
      timestamp: timestamp,
      why: why,
      feedback: feedback,
      imagesPath: imagesPath,
    );
  }

  Future<void> deleteMood(
      {required int timestamp, required String date}) async {
    _moodWebServices.deleteMood(timestamp: timestamp, date: date);

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

  Future<List<String>> getImagesURL(List<dynamic> paths) async {
    return await _moodWebServices.getImagesURL(paths);
  }
}
