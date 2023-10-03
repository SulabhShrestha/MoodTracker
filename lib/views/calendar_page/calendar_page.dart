import 'dart:collection';

import 'package:flutter/material.dart';

import '../../view_models/calendar_list_view_model.dart';
import '../../view_models/mood_view_model.dart';
import 'widgets/calendar.dart';

/// This page is responsible for showing what happened in a specific month

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: FutureBuilder<LinkedHashMap<DateTime, List<MoodViewModel>>>(
          future: CalendarListViewModel().populateCalendar(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return const Center(child: Text("Nothing to display"));
              }
              return Calendar(moods: snapshot.data!);
            }

            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
