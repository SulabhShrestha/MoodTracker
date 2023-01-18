import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mood_tracker/views/stats/widgets/feeling_card.dart';
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
          future: statsListViewModel.fetch(filter: filter),
          builder: (_, snapshot) {
            log("Stats page building");
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: <Widget>[
                  DropDownButton(
                    text: dropDownButtonText,
                    onChanged: (value) {
                      setState(() {
                        dropDownButtonText = value;
                        if (value == "All time") {
                          filter = Filters.allTime;
                        } else if (value == "This week") {
                          filter = Filters.thisWeek;
                        } else if (value == "This month") {
                          filter = Filters.thisMonth;
                        } else {
                          filter = Filters.rangeDate;
                        }
                      });
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
