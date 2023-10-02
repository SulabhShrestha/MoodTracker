import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker/providers/week_first_day_provider.dart';
import 'package:mood_tracker/utils/constant.dart';
import 'package:mood_tracker/view_models/mood_view_model.dart';
import 'package:mood_tracker/view_models/week_first_day_view_model.dart';
import 'package:mood_tracker/views/core/single_item_card.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../utils/date_helper_utils.dart';
import '../utils.dart' as utils;

class Calendar extends ConsumerStatefulWidget {
  final LinkedHashMap<DateTime, List<MoodViewModel>> moods;

  const Calendar({super.key, required this.moods});

  @override
  ConsumerState<Calendar> createState() => _CalendarState();
}

class _CalendarState extends ConsumerState<Calendar> {
  // for knowing if the selected days have any event to display

  late final ValueNotifier<List<MoodViewModel>> _selectedEvents;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // for making viewing spaces more by hiding calendar dates
  CalendarFormat currentCalendarFormat = CalendarFormat.month;

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

  // for showing header button
  bool showHeaderButton = true;

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar<MoodViewModel>(
          calendarFormat: currentCalendarFormat,
          firstDay: widget.moods.keys.first,
          rangeEndDay: utils.kLastDay,
          headerStyle: HeaderStyle(
            formatButtonVisible: showHeaderButton,
            titleCentered: true,
            formatButtonDecoration: BoxDecoration(
              color: Constant().colors.blue,
              border: Border.all(color: Constant().colors.primary),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ),
          onFormatChanged: (format) {
            setState(() => currentCalendarFormat = format);
          },
          availableCalendarFormats: const {
            CalendarFormat.month: 'Month',
            CalendarFormat.week: 'Week',
          },
          calendarBuilders: CalendarBuilders(
            // for displaying today
            todayBuilder: (context, date, _) {
              return Container(
                margin: const EdgeInsets.all(4),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  date.day.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              );
            },

            // marker for how many events in that day
            markerBuilder: (context, date, events) {
              if (events.isEmpty) {
                return null;
              }
              return Positioned(
                bottom: 1,
                right: 1,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    events.length.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },

            // for displaying selected day
            selectedBuilder: (context, date, _) {
              return Container(
                margin: const EdgeInsets.all(4),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Constant().colors.yellow,
                  border: Border.all(color: Constant().colors.primary),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  date.day.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              );
            },
          ),
          lastDay: utils.kLastDay,
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          eventLoader: _getEventsForDay,
          startingDayOfWeek: DateHelperUtils().firstDayOfWeekString(
              firstDayOfWeek: ref.watch(weekFirstDayProvider)),
          calendarStyle: const CalendarStyle(
            markerSize: 10,
            markersMaxCount: 24,
            outsideDaysVisible: false,
            canMarkersOverflow: true,
          ),
          onDaySelected: _onDaySelected,
        ),
        Expanded(
          child: ValueListenableBuilder<List<MoodViewModel>>(
            valueListenable: _selectedEvents,
            builder: (context, moodViewModels, _) {
              if (moodViewModels.isEmpty) {
                showHeaderButton = false;
              } else {
                showHeaderButton = true;
              }

              return ListView.builder(
                itemCount: moodViewModels.length,
                itemBuilder: (context, index) {
                  return SingleItemCard(
                    date: moodViewModels[index].date,
                    dateLabel: DateHelperUtils()
                        .getDateLabel(moodViewModels[index].date),
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
    );
  }
}
