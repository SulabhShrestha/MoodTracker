import 'dart:developer';
import 'dart:ui';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker/providers/week_first_day_provider.dart';
import 'package:mood_tracker/view_models/calendar_list_view_model.dart';
import 'package:mood_tracker/view_models/week_first_day_view_model.dart';

import '../utils.dart' as utils;

class StartEndDatePicker extends ConsumerStatefulWidget {
  final DateTime firstDate; // first date from the entered moods
  const StartEndDatePicker({super.key, required this.firstDate});

  @override
  ConsumerState<StartEndDatePicker> createState() => _StartEndDatePickerState();
}

class _StartEndDatePickerState extends ConsumerState<StartEndDatePicker> {
  var startText = "Start Date";
  var endText = "End Date";

  Map<String, DateTime> startEndTimes = {};

  @override
  Widget build(BuildContext context) {

    return AlertDialog(

      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          DatePicker(
              text: startText,
              onClick: () async {
                var res = await ShowDatePicker().selectStartDate(
                    context, widget.firstDate, ref.watch(weekFirstDayProvider));
                if (res != null) {
                  startEndTimes["startDate"] = res;
                  setState(() {
                    startText = "${res.year}-${res.month}-${res.day}";
                  });
                }
              }),
          DatePicker(
              text: endText,
              onClick: () async {
                var res = await ShowDatePicker().selectEndDate(
                    context, widget.firstDate, ref.watch(weekFirstDayProvider));
                if (res != null) {
                  startEndTimes["endDate"] =
                      DateTime(res.year, res.month, res.day, 23, 59, 59, 999);
                  log(startEndTimes["endDate"].toString());
                  setState(() {
                    endText = "${res.year}-${res.month}-${res.day}";
                  });
                }
              }),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (startText == endText) {
              log("Same");
            } else if (startText == "Start Date" || endText == "End Date") {
              log("Empty date");
            } else {
              Navigator.pop<Map<String, DateTime>>(context, startEndTimes);
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class DatePicker extends StatelessWidget {
  final String text;
  final VoidCallback onClick;
  const DatePicker({super.key, required this.text, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        decoration: BoxDecoration(border: Border.all()),
        child: Row(
          children: [
            const Icon(Icons.calendar_today),
            const SizedBox(width: 4),
            Text(text),
          ],
        ),
      ),
    );
  }
}

class ShowDatePicker {
  Future<DateTime?> selectStartDate(
      BuildContext context, DateTime firstDate, String firstDayOfWeek) async {
    final DateTime? date = await showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            child: CalendarDatePicker2WithActionButtons(
              onCancelTapped: () {
                Navigator.of(context).pop(null);
              },
              onValueChanged: (datetime) {
                Navigator.of(context).pop(datetime.first);
              },
              config: CalendarDatePicker2WithActionButtonsConfig(
                calendarType: CalendarDatePicker2Type.single,
                disableModePicker: true,
                firstDate: firstDate,
                lastDate: DateTime.now(),
                firstDayOfWeek:
                    utils.firstDayOfWeekInt(firstDayOfWeek: firstDayOfWeek),
              ),
              value: [DateTime.now()],
            ),
          );
        });
    return date;
  }

  Future<DateTime?> selectEndDate(
      BuildContext context, DateTime firstDate, String firstDayOfWeek) async {
    final DateTime? date = await showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            child: CalendarDatePicker2WithActionButtons(
              onCancelTapped: () {
                Navigator.of(context).pop(null);
              },
              onValueChanged: (datetime) {
                Navigator.of(context).pop(datetime.first);
              },
              config: CalendarDatePicker2WithActionButtonsConfig(
                calendarType: CalendarDatePicker2Type.single,
                disableModePicker: true,
                firstDate: firstDate,
                lastDate: DateTime.now(),
                firstDayOfWeek:
                    utils.firstDayOfWeekInt(firstDayOfWeek: firstDayOfWeek),
              ),
              value: [DateTime.now()],
            ),
          );
        });
    return date;
  }
}
