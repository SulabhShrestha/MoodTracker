import 'dart:collection';

import 'package:mood_tracker/services/calendar_web_services.dart';

import 'mood_view_model.dart';

class CalendarListViewModel {
  final _calendarWebServices = CalendarWebServices();

  Future<LinkedHashMap<DateTime, List<MoodViewModel>>>
      populateCalendar() async {
    LinkedHashMap<DateTime, List<MoodViewModel>> moods = LinkedHashMap();

    var res = await _calendarWebServices.getAllMoodsDateTime();
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
    return await _calendarWebServices.getFirstEnteredMoodDateTime();
  }
}
