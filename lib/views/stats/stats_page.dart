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
  Filters filters = Filters.allTime;

  @override
  void initState() {
    Provider.of<StatsListViewModel>(context, listen: false).fetchAllTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final statsListViewModel = Provider.of<StatsListViewModel>(context);

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<MoodStats>>(
          future: statsListViewModel.fetchAllTime(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: <Widget>[
                  const DropDownButton(),
                  DisplayPieChart(moodsStats: snapshot.data!),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: List.generate(
                        snapshot.data!.length,
                        (index) => FeelingCard(
                              rating: snapshot.data![index].rating,
                              totalOccurrence: snapshot.data![index].occurrence,
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
