import 'package:mood_tracker/models/time_stamp.dart';

import '../models/mood.dart';

class MoodViewModel {
  final Mood mood;

  MoodViewModel({required this.mood});

  int get rating => mood.rating;
  String get date => mood.date;
  TimeStamp get timestamp => mood.timestamp;

  String? get reason => mood.why;
  String? get feedback => mood.feedback;
}
