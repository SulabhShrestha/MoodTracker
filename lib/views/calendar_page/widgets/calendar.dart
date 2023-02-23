import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:mood_tracker/view_models/mood_view_model.dart';
import 'package:mood_tracker/views/core/single_item_card.dart';
import 'package:table_calendar/table_calendar.dart';

import '../utils.dart';

class Calendar extends StatefulWidget {
  final LinkedHashMap<DateTime, List<MoodViewModel>> moods;

  const Calendar({super.key, required this.moods});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  // for knowing if the selected days have any event to display
  late final ValueNotifier<List<MoodViewModel>> _selectedEvents;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  var kEvents = LinkedHashMap<DateTime, List<MoodViewModel>>(
    equals: (DateTime? a, DateTime? b) {
      if (a == null || b == null) {
        return false;
      }
      return a.year == b.year && a.month == b.month && a.day == b.day;
    },
    hashCode: (DateTime key) =>
        key.day * 1000000 + key.month * 10000 + key.year,
  );

  @override
  void initState() {
    super.initState();

    kEvents.addAll(widget.moods);

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<MoodViewModel> _getEventsForDay(DateTime date) {
    // if selected days has no event then return empty
    return kEvents[date] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Column(
        children: [
          TableCalendar<MoodViewModel>(
            firstDay: kFirstDay,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, date, _) {
                final isAfterToday = date.isAfter(DateTime.now());

                return Center(
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(
                      color: isAfterToday ? Colors.grey : Colors.black,
                    ),
                  ),
                );
              },
            ),
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            calendarStyle: const CalendarStyle(
              markerSize: 10,
              markersMaxCount: 24,
              outsideDaysVisible: false,
              canMarkersOverflow: true,
            ),
            onDaySelected: _onDaySelected,
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<MoodViewModel>>(
              valueListenable: _selectedEvents,
              builder: (context, moodViewModels, _) {
                return ListView.builder(
                  itemCount: moodViewModels.length,
                  itemBuilder: (context, index) {
                    return SingleItemCard(
                      date: moodViewModels[index].date,
                      rating: moodViewModels[index].rating,
                      timeStamp: moodViewModels[index].timestamp,
                      feedback: moodViewModels[index].feedback,
                      reason: moodViewModels[index].reason,
                      showEditDeleteButton: false,
                      dbImagesPath: moodViewModels[index].imagesURL,
                      showImageDeleteBtn: false,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
