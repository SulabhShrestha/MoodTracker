import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/mood_stats.dart';
import '../../view_models/stats_list_view_model.dart';
import 'utils.dart';
import 'widgets/display_pie_chart.dart';
import 'widgets/drop_down_box.dart';
import 'widgets/feeling_card.dart';
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
        child: SizedBox(
          width: double.infinity,
          child: FutureBuilder<Map<String, dynamic>>(
            future: statsListViewModel.fetch(
              filter: filter,
              startTimestamp: startTimestamp,
              endTimestamp: endTimestamp,
            ),
            builder: (_, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                List<MoodStats> moodsStats = snapshot.data!["data"];
                int docsSize = snapshot.data!["docsSize"];
                log("Stats page building and size: $docsSize}");

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    DropDownButton(
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
                            endTimestamp =
                                res["endDate"].millisecondsSinceEpoch;
                          }
                          log("Stats page: ${res.toString()}");
                        }
                        if (rebuildWidget) {
                          rebuildWidget = false;
                          setState(() {});
                        }
                      },
                    ),
                    if (docsSize == 0) const Text("Nothing to display."),
                    if (docsSize > 0) ...[
                      DisplayPieChart(moodsStats: snapshot.data!["data"]),
                      Wrap(
                        alignment: WrapAlignment.center,
                        children: List.generate(
                            moodsStats.length, // currently 5
                            (index) => FeelingCard(
                                  feeling: moodsStats[index].feeling,
                                  totalOccurrence: moodsStats[index].occurrence,
                                  color: colors[index],
                                )),
                      ),
                    ],
                  ],
                );
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
