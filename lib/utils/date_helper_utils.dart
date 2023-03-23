import 'dart:developer';
import 'dart:ui';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/date_symbols.dart';
import 'package:table_calendar/table_calendar.dart';

class DateHelperUtils {
  StartingDayOfWeek firstDayOfWeekString({required String firstDayOfWeek}) {
    if (firstDayOfWeek == "Auto") {
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
    } else if (firstDayOfWeek == "Monday") {
      return StartingDayOfWeek.monday;
    } else if (firstDayOfWeek == "Tuesday") {
      return StartingDayOfWeek.tuesday;
    } else if (firstDayOfWeek == "Saturday") {
      return StartingDayOfWeek.saturday;
    } else {
      return StartingDayOfWeek.sunday;
    }
  }

  String getDateLabel(String dateString) {
    DateTime date = DateTime.parse(dateString);
    DateTime today = DateTime.now();
    DateTime yesterday = today.subtract(const Duration(days: 1));

    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return "Today";
    } else if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return "Yesterday";
    } else {
      return _getWeekdayName(date.weekday);
    }
  }

  String _getWeekdayName(int weekday) {
    switch (weekday) {
      case DateTime.sunday:
        return "Sunday";
      case DateTime.monday:
        return "Monday";
      case DateTime.tuesday:
        return "Tuesday";
      case DateTime.wednesday:
        return "Wednesday";
      case DateTime.thursday:
        return "Thursday";
      case DateTime.friday:
        return "Friday";
      case DateTime.saturday:
        return "Saturday";

      default:
        return "";
    }
  }
}
