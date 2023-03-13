import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/mood_stats.dart';
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
  void initState() {
    Provider.of<StatsListViewModel>(context, listen: false)
        .fetch(filter: filter);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final statsListViewModel = Provider.of<StatsListViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter'),
      ),
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

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    if (docsSize == 0) const Text("Nothing to display."),
                    if (docsSize > 0) ...[
                      Stack(
                        children: [
                          DisplayPieChart(moodsStats: snapshot.data!["data"]),
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
                                    startTimestamp =
                                        res["startDate"].millisecondsSinceEpoch;
                                    endTimestamp =
                                        res["endDate"].millisecondsSinceEpoch;
                                  }
                                }
                                if (rebuildWidget) {
                                  rebuildWidget = false;
                                  setState(() {});
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
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
