import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mood_tracker/views/stats/widgets/feeling_card.dart';
import 'package:mood_tracker/views/stats/widgets/start_end_date_picker.dart';
import 'package:provider/provider.dart';

import '../../models/mood_stats.dart';
import '../../view_models/stats_list_view_model.dart';
import 'utils.dart';
import 'widgets/display_pie_chart.dart';
import 'widgets/drop_down_box.dart';

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

  @override
  void initState() {
    Provider.of<StatsListViewModel>(context, listen: false)
        .fetch(filter: filter);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final statsListViewModel = Provider.of<StatsListViewModel>(context);

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<MoodStats>>(
          future: statsListViewModel.fetch(
            filter: filter,
            startTimestamp: startTimestamp,
            endTimestamp: endTimestamp,
          ),
          builder: (_, snapshot) {
            log("Stats page building");
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: <Widget>[
                  DropDownButton(
                    text: dropDownButtonText,
                    onChanged: (value) async {
                      if (value == "All time") {
                        filter = Filters.allTime;
                        dropDownButtonText = value;
                        rebuildWidget = true;
                      } else if (value == "This week") {
                        filter = Filters.thisWeek;
                        dropDownButtonText = value;
                        rebuildWidget = true;
                      } else if (value == "This month") {
                        filter = Filters.thisMonth;
                        dropDownButtonText = value;
                        rebuildWidget = true;
                      } else {
                        var res = await showDialog<dynamic>(
                            context: context,
                            builder: (_) {
                              return const StartEndDatePicker();
                            });

                        if (res != null) {
                          rebuildWidget = true;
                          dropDownButtonText = value;
                          filter = Filters.rangeDate;
                          log("StartDate: ${res["startDate"]}, EndDate: ${res["endDate"]}");
                          startTimestamp =
                              res["startDate"].millisecondsSinceEpoch;
                          endTimestamp = res["endDate"].millisecondsSinceEpoch;
                        }
                        log("Stats page: ${res.toString()}");
                      }
                      if (rebuildWidget) {
                        rebuildWidget = false;
                        setState(() {});
                      }
                    },
                  ),
                  DisplayPieChart(moodsStats: snapshot.data!),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: List.generate(
                        snapshot.data!.length,
                        (index) => FeelingCard(
                              feeling: snapshot.data![index].feeling,
                              totalOccurrence: snapshot.data![index].occurrence,
                              color: colors[index],
                            )),
                  ),
                ],
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
