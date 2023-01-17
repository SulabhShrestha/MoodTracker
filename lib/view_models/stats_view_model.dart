import '../models/mood_stats.dart';

class StatsViewModel {
  final MoodStats stats;

  StatsViewModel({required this.stats});

  int get rating => stats.rating;
  int get occurrence => stats.occurrence;
}
