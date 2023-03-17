import 'dart:developer';
import 'dart:ui';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/date_symbols.dart';
import 'package:table_calendar/table_calendar.dart';

final kToday = DateTime.now();
final kLastDay = DateTime(kToday.year, kToday.month, kToday.day);

StartingDayOfWeek firstDayOfWeek() {
  Locale currentLocale = window.locale; // getting current locale
  log("Current Locale: ${currentLocale.languageCode}");

  var dateSymbolMap = dateTimeSymbolMap();
  DateSymbols dateSymbols =
      dateSymbolMap[currentLocale.languageCode.toString()];
  log("first day: ${dateSymbols.FIRSTDAYOFWEEK}");

  switch (dateSymbols.FIRSTDAYOFWEEK) {
    case 0:
      return StartingDayOfWeek.monday;

    case 1:
      return StartingDayOfWeek.tuesday;

    case 5:
      return StartingDayOfWeek.saturday;

    default:
      return StartingDayOfWeek.sunday;
  }
}
