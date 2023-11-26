import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mood_tracker/view_models/calendar_list_view_model.dart';

import '../../view_models/stats_list_view_model.dart';
import 'utils.dart';
import 'widgets/display_pie_chart.dart';
import 'widgets/drop_down_box.dart';
import 'widgets/start_end_date_picker.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  Filters filter = Filters.allTime;
  bool showLoading = false; // when filtering takes place

  String dropDownButtonText = "All time";

  int? startTimestamp, endTimestamp;

  bool rebuildWidget = false;

  int currentTouchIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter'),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: FutureBuilder<Map<String, dynamic>>(
            future: StatsListViewModel().fetch(
              filter: filter,
              startTimestamp: startTimestamp,
              endTimestamp: endTimestamp,
            ),
            builder: (_, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                int docsSize = snapshot.data!["docsSize"];

                return Stack(
                  children: [
                    if (docsSize > 0)
                      DisplayPieChart(moodsStats: snapshot.data!["data"]),
                    if (docsSize == 0)
                      const SizedBox(
                        height: double.infinity,
                        child: Center(child: Text("Nothing to display.")),
                      ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: DropDownButton(
                        text: dropDownButtonText,
                        onChanged: (value) async {
                          if (value == "All time") {
                            filter = Filters.allTime;
                            dropDownButtonText = value;
                            rebuildWidget = true;
                          } else if (value == "This month") {
                            filter = Filters.thisMonth;
                            dropDownButtonText = value;
                            rebuildWidget = true;
                          } else if (value == "This week") {
                            filter = Filters.thisWeek;
                            dropDownButtonText = value;
                            rebuildWidget = true;
                          } else {
                            CalendarListViewModel()
                                .getFirstEnteredMoodDateTime()
                                .then((date) async {
                              var res = await showDialog<dynamic>(
                                  context: context,
                                  builder: (_) {
                                    return StartEndDatePicker(
                                      firstDate: date,
                                    );
                                  });

                              if (res != null) {
                                rebuildWidget = true;
                                log("res: $res");
                                String startDate = "", endDate = "";

                                dropDownButtonText =
                                    "${res["startDate"]} - ${res["endDate"]}"; // "2021-09-01 - 2021-09-30"

                                log("Set Date: $dropDownButtonText");
                                filter = Filters.rangeDate;
                                startTimestamp =
                                    res["startDate"].millisecondsSinceEpoch;
                                endTimestamp =
                                    res["endDate"].millisecondsSinceEpoch;
                              }
                            }).onError((error, stackTrace) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Nothing to select."),
                                ),
                              );
                            });
                          }
                          if (rebuildWidget) {
                            rebuildWidget = false;
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ],
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
