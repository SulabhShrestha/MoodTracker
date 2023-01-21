import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mood_tracker/services/stats_web_services.dart';

import '../models/mood_stats.dart';
import '../views/stats_page/utils.dart';

class StatsListViewModel extends ChangeNotifier {
  final _statsWebServices = StatsWebServices();

  Future<List<MoodStats>> fetch(
      {required Filters filter, int? startTimestamp, int? endTimestamp}) async {
    List<MoodStats> stats;

    switch (filter) {
      case Filters.allTime:
        stats = await _statsWebServices.fetchAllTime();
        break;

      case Filters.thisMonth:
        stats = await _statsWebServices.fetchThisMonth();
        break;

      case Filters.thisWeek:
        stats = await _statsWebServices.fetchThisWeek();
        break;

      case Filters.rangeDate:
        log("I came here: $startTimestamp $endTimestamp $filter");
        stats = await _statsWebServices.fetchRange(
            startTimestamp: startTimestamp!, endTimestamp: endTimestamp!);
        break;
    }

    return stats;
  }
}
