import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mood_tracker/extension/double_ext.dart';
import 'package:mood_tracker/views/stats_page/utils.dart';

import '../../../models/mood_stats.dart';

class DisplayPieChart extends StatefulWidget {
  final List<MoodStats> moodsStats;

  const DisplayPieChart({super.key, required this.moodsStats});

  @override
  State<StatefulWidget> createState() => PieChartState();
}

class PieChartState extends State<DisplayPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            const SizedBox(
              height: 18,
            ),
            Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: showingSections(widget.moodsStats),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(List<MoodStats> moodsStats) {
    return List.generate(moodsStats.length, (i) {
      return PieChartSectionData(
        color: colors[i],
        value: moodsStats[i].percentage,
        title:
            '${double.parse(moodsStats[i].percentage.toStringAsFixed(2)).removeDecimalZeroFormat}%',
        radius: 50.0,
        titleStyle: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Color(0xffffffff),
        ),
      );
    });
  }
}
