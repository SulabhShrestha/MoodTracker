import 'dart:developer';
import 'dart:ui';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:mood_tracker/view_models/calendar_list_view_model.dart';

import '../utils.dart' as utils;

class StartEndDatePicker extends StatefulWidget {
  const StartEndDatePicker({Key? key}) : super(key: key);

  @override
  State<StartEndDatePicker> createState() => _StartEndDatePickerState();
}

class _StartEndDatePickerState extends State<StartEndDatePicker> {
  var startText = "Start Date";
  var endText = "End Date";

  Map<String, DateTime> startEndTimes = {};

  var firstDate = DateTime(1970); // dummy

  @override
  void initState() {
    fetchNecessary();
    super.initState();
  }

  void fetchNecessary() async {
    firstDate = await CalendarListViewModel().getFirstEnteredMoodDateTime();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          DatePicker(
              text: startText,
              onClick: () async {
                var res =
                    await ShowDatePicker().selectStartDate(context, firstDate);
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
                var res =
                    await ShowDatePicker().selectEndDate(context, firstDate);
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
  const DatePicker({Key? key, required this.text, required this.onClick})
      : super(key: key);

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
      BuildContext context, DateTime firstDate) async {
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
                firstDayOfWeek: utils.firstDayOfWeekInt(),
              ),
              initialValue: [DateTime.now()],
            ),
          );
        });
    return date;
  }

  Future<DateTime?> selectEndDate(
      BuildContext context, DateTime firstDate) async {
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
                firstDayOfWeek: utils.firstDayOfWeekInt(),
              ),
              initialValue: [DateTime.now()],
            ),
          );
        });
    return date;
  }
}
