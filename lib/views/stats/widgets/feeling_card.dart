import 'package:flutter/material.dart';

class FeelingCard extends StatelessWidget {
  final int totalOccurrence;
  final int rating;
  const FeelingCard(
      {Key? key, required this.rating, required this.totalOccurrence})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          const CircleAvatar(),
          Text("$totalOccurrence times"),
          Text("Feeling $rating"),
        ],
      ),
    );
  }
}
