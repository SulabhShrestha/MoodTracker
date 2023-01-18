import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mood_tracker/extension/double_ext.dart';
import 'package:mood_tracker/views/stats/utils.dart';

import '../../../models/mood_stats.dart';
import 'indicator.dart';

//https://github.com/imaNNeoFighT/fl_chart/blob/master/example/lib/pie_chart/samples/pie_chart_sample2.dart
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
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(
                      show: true,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: showingSections(widget.moodsStats),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 4,
              bottom: 12,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                    5,
                    (index) => Column(
                          children: [
                            Indicator(
                              color: colors[index],
                              text: widget.moodsStats[index].feeling,
                              isSquare: true,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                          ],
                        )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(List<MoodStats> moodsStats) {
    return List.generate(moodsStats.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;

      return PieChartSectionData(
        color: colors[i],
        value: moodsStats[i].percentage,
        title: double.parse(moodsStats[i].percentage.toStringAsFixed(2))
            .removeDecimalZeroFormat
            .toString(),
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
        ),
      );
    });
  }
}
