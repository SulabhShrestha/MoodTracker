import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mood_tracker/services/stats_web_services.dart';

import '../views/stats_page/utils.dart';

class StatsListViewModel extends ChangeNotifier {
  final _statsWebServices = StatsWebServices();

  Future<Map<String, dynamic>> fetch(
      {required Filters filter, int? startTimestamp, int? endTimestamp}) async {
    Map<String, dynamic> stats;

    switch (filter) {
      case Filters.allTime:
        stats = await _statsWebServices.fetchAllTime();
        break;

      case Filters.thisMonth:
        stats = await _statsWebServices.fetchThisMonth();
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
