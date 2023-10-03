import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mood_tracker/extension/double_ext.dart';
import 'package:mood_tracker/utils/emoji_utils.dart';
import 'package:mood_tracker/views/stats_page/utils.dart';

import '../../../models/mood_stats.dart';
import 'feeling_card.dart';

//https://github.com/imaNNeo/fl_chart/blob/master/example/lib/presentation/samples/pie/pie_chart_sample2.dart
class DisplayPieChart extends StatefulWidget {
  final List<MoodStats> moodsStats;

  const DisplayPieChart({super.key, required this.moodsStats});

  @override
  State<StatefulWidget> createState() => PieChartState();
}

class PieChartState extends State<DisplayPieChart> {
  int currentTouchIndex = -1;
  @override
  Widget build(BuildContext context) {
    final displayableMoodsStats =
        widget.moodsStats.where((mood) => mood.occurrence > 0).toList();

    return SingleChildScrollView(
      child: Column(
        children: [
          AspectRatio(
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
                          sections: showingSections(displayableMoodsStats),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Feelings card
          Wrap(
            alignment: WrapAlignment.center,
            children: List.generate(
                displayableMoodsStats.length,
                (index) => GestureDetector(
                      onTap: () {
                        setState(() => currentTouchIndex = index);

                        // Resetting the currentTouchIndex back to normal
                        Future.delayed(const Duration(milliseconds: 700), () {
                          setState(() => currentTouchIndex = -1);
                        });
                      },
                      child: FeelingCard(
                        iconSvgPath: EmojiUtils.getSvgPath(index + 1),
                        feeling: displayableMoodsStats[index].feeling,
                        totalOccurrence:
                            displayableMoodsStats[index].occurrence,
                        color: colors[index],
                      ),
                    )),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections(List<MoodStats> moodsStats) {
    return List.generate(moodsStats.length, (i) {
      double value = moodsStats[i].percentage;

      // 60.0 => 60, 60.66 => 60.66
      var displayingValue = value.remainder(1) == 0
          ? value.toInt()
          : double.parse(value.toStringAsFixed(2)).removeDecimalZeroFormat;

      return PieChartSectionData(
        color: colors[i],
        value: value,
        title: '$displayingValue%',
        radius: currentTouchIndex == i ? 60 : 50.0,
        titleStyle: TextStyle(
          fontSize: currentTouchIndex == i ? 24.0 : 16.0,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
        ),
      );
    });
  }
}
