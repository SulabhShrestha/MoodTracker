import 'package:flutter/material.dart';
import 'package:mood_tracker/views/stats/widgets/feeling_card.dart';

import 'widgets/drop_down_box.dart';
import 'widgets/pie_chart.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const DropDownButton(),
            const DisplayPieChart(),
            Wrap(
              alignment: WrapAlignment.center,
              children: List.generate(5, (index) => FeelingCard()),
            ),
          ],
        ),
      ),
    );
  }
}
