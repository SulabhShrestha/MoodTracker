import '../models/mood.dart';

class MoodViewModel {
  final Mood mood;

  MoodViewModel({required this.mood});

  int get rating => mood.rating;

  String? get reason => mood.why;

  String get date => mood.date;

  String? get feedback => mood.feedback;
}
