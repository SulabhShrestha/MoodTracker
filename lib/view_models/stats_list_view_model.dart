import 'package:flutter/material.dart';
import 'package:mood_tracker/services/stats_web_services.dart';

import '../models/mood_stats.dart';

class StatsListViewModel extends ChangeNotifier {
  final _statsWebServices = StatsWebServices();

  // rating : List<>

  Future<List<MoodStats>> fetchAllTime() async {
    List<MoodStats> stats = await _statsWebServices.fetchAllTime();

    return stats;
  }
}
