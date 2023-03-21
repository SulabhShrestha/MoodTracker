import 'dart:collection';

import '../services/mood_web_services.dart';
import 'mood_view_model.dart';

class CalendarListViewModel {
  final _moodWebServices = MoodWebServices();

  Future<LinkedHashMap<DateTime, List<MoodViewModel>>>
      populateCalendar() async {
    LinkedHashMap<DateTime, List<MoodViewModel>> moods = LinkedHashMap();

    var res = await _moodWebServices.getAllMoodsDateTime();
    for (var element in res.entries) {
      List<MoodViewModel> list = [];

      for (var mood in element.value) {
        list.add(MoodViewModel(mood: mood));
      }

      moods[element.key] = list;
    }

    return moods;
  }

  Future<DateTime> getFirstEnteredMoodDateTime() async {
    return await _moodWebServices.getFirstEnteredMoodDateTime();
  }
}
