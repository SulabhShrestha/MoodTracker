import 'package:flutter/material.dart';

import 'widgets/calendar.dart';

/// This page is responsible for showing what happened in a specific month

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TableEventsExample(),
    );
  }
}
