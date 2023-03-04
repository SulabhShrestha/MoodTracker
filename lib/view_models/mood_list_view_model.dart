import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:mood_tracker/models/mood.dart';
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

  Future<Map<String, List<Mood>>> searchMoodsByKeyword(
      {required String searchKeyword}) async {
    return await _moodWebServices.searchMoodsByKeyword(
        searchKeyword: searchKeyword.toLowerCase());
  }

  Future<void> deleteMood(
      {required int timestamp, required String date}) async {
    _moodWebServices.deleteMood(timestamp: timestamp, date: date);

    notifyListeners();
  }

  Future<void> updateMoodDB({
    required int rating,
    required int timestamp,
    required String date,
    String? why,
    String? feedback,
    List<String?>? storageImagesPath,
  }) async {
    await _moodWebServices.updateMood(
      timestamp: timestamp,
      rating: rating,
      date: date,
      feedback: feedback,
      why: why,
      storageImagesPath: storageImagesPath,
    );
  }

  Future<List<String>> getImagesURL(List<dynamic> paths) async {
    return await _moodWebServices.getImagesURL(paths);
  }

  Future<List<String>> uploadImages({
    required List<String?> localPaths,
    required String date,
    required int timestamp,
  }) async {
    return await _moodWebServices.uploadImages(
        localPaths: localPaths, date: date, timestamp: timestamp);
  }

  Future<void> deleteImages({
    required List<String> deletingImagePaths,
    required String date,
    required int timestamp,
    List<dynamic> updatedImagesPath = const [],
    bool updateToFirestore = true,
  }) async {
    await _moodWebServices.deleteImages(
        deletingImagePaths: deletingImagePaths,
        date: date,
        timestamp: timestamp,
        updatedImagesPath: updatedImagesPath,
        updateToFirestore: updateToFirestore);
  }
}
