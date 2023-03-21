import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/date_symbols.dart';

// Used for filtering stats pages
enum Filters {
  allTime,
  thisMonth,
  rangeDate,
  thisWeek,
}

List<MaterialColor> colors = [
  Colors.blue,
  Colors.green,
  Colors.teal,
  Colors.deepPurple,
  Colors.cyan,
];

int firstDayOfWeekInt() {
  Locale currentLocale = window.locale; // getting current locale
  log("Current Locale: ${currentLocale.languageCode}");

  var dateSymbolMap = dateTimeSymbolMap();
  DateSymbols dateSymbols =
      dateSymbolMap[currentLocale.languageCode.toString()];
  log("first day: ${dateSymbols.FIRSTDAYOFWEEK}");

  // 0 means monday in [dateSymbols.FIRSTDAYOFWEEK]
  // but for [CalendarDatePicker2WithAction] 0 is sunday
  switch (dateSymbols.FIRSTDAYOFWEEK) {
    case 0: // monday
      return 1;

    case 1: // tuesday
      return 2;

    case 5: // saturday
      return 6;

    default: // sunday
      return 0;
  }
}
