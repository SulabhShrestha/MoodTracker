import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker/models/first_day_of_week_model.dart';

// This will store first day of  week
final firstDayOfWeekModelProvider = Provider<FirstDayOfWeekModel>((ref) {
  return FirstDayOfWeekModel();
});
