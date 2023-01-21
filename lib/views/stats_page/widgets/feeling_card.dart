import 'package:flutter/material.dart';

class FeelingCard extends StatelessWidget {
  final int totalOccurrence;
  final String feeling;
  final Color? color;
  const FeelingCard(
      {Key? key,
      required this.feeling,
      required this.totalOccurrence,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          CircleAvatar(backgroundColor: color),
          Text("$totalOccurrence times"),
          Text("Feeling $feeling"),
        ],
      ),
    );
  }
}
