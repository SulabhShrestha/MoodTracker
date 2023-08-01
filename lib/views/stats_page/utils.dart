import 'dart:ui';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/date_symbols.dart';
import 'package:mood_tracker/utils/constant.dart';

// Used for filtering stats pages
enum Filters {
  allTime,
  thisMonth,
  rangeDate,
  thisWeek,
}

List<Color> colors = [
  Constant().colors.blue,
  Constant().colors.green,
  Constant().colors.orange,
  Constant().colors.purple,
  Constant().colors.red,
];

int firstDayOfWeekInt({required String firstDayOfWeek}) {
  if (firstDayOfWeek == "Auto") {
    Locale currentLocale = window.locale; // getting current locale

    var dateSymbolMap = dateTimeSymbolMap();
    DateSymbols dateSymbols =
        dateSymbolMap[currentLocale.languageCode.toString()];

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
  } else if (firstDayOfWeek == "Monday") {
    return 1;
  } else if (firstDayOfWeek == "Tuesday") {
    return 2;
  } else if (firstDayOfWeek == "Saturday") {
    return 6;
  }

  // sunday
  else {
    return 0;
  }
}
