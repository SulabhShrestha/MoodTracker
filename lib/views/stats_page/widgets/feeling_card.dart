import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mood_tracker/utils/constant.dart';

class FeelingCard extends StatelessWidget {
  final int totalOccurrence;
  final String feeling;
  final Color? color;
  final String iconSvgPath;

  const FeelingCard(
      {Key? key,
      required this.feeling,
      required this.totalOccurrence,
      required this.iconSvgPath,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Constant().colors.primary),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SvgPicture.string(
              iconSvgPath,
              height: 46,
              width: 46,
            ),
            Text("$totalOccurrence times"),
            Text("Feeling $feeling"),
          ],
        ),
      ),
    );
  }
}
