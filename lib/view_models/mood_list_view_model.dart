import 'package:mood_tracker/services/mood_web_services.dart';

class MoodListViewModel {
  Future<void> addNewMood(
      {required int rating, String? why, String? feedback}) async {
    await MoodWebServices().add(rating: rating, why: why, feedback: feedback);
  }
}
