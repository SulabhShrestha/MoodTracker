import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mood_tracker/services/stats_web_services.dart';

import '../models/mood_stats.dart';
import '../views/stats/utils.dart';

class StatsListViewModel extends ChangeNotifier {
  final _statsWebServices = StatsWebServices();

  Future<List<MoodStats>> fetch({required Filters filter}) async {
    List<MoodStats> stats;

    switch (filter) {
      case Filters.allTime:
        stats = await _statsWebServices.fetchAllTime();

        for (var elem in stats) {
          log("rating: ${elem.rating}, occ: ${elem.occurrence}");
        }
        break;

      case Filters.thisMonth:
        stats = await _statsWebServices.fetchThisMonth();
        for (var elem in stats) {
          log("rating: ${elem.rating}, occ: ${elem.occurrence}");
        }
        break;

      case Filters.thisWeek:
        stats = await _statsWebServices.fetchThisWeek();
        for (var elem in stats) {
          log("rating: ${elem.rating}, occ: ${elem.occurrence}");
        }
        break;

      case Filters.rangeDate:
        stats = await _statsWebServices.fetchAllTime();
        break;
    }

    return stats;
  }
}
