import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:mood_tracker/services/mood_web_services.dart';
import 'package:mood_tracker/view_models/mood_view_model.dart';

import '../models/mood.dart';

class MoodListViewModel extends ChangeNotifier {
  final _moodWebServices = MoodWebServices();
  List<MoodViewModel> moods = [];

  Future<void> addNewMood(
      {required int rating, String? why, String? feedback}) async {
    await _moodWebServices.addNewMood(
        rating: rating, why: why, feedback: feedback);

    await fetchAllMoods();
  }

  Future<void> fetchAllMoods() async {
    List<Mood> res = await _moodWebServices.getAllMoodInSingle();
    moods = res.map((mood) => MoodViewModel(mood: mood)).toList();
    notifyListeners();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> get stream =>
      FirebaseFirestore.instance.collection("Mood").snapshots();
}
