import 'package:flutter/material.dart';

class FeelingCard extends StatelessWidget {
  const FeelingCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          CircleAvatar(),
          Text("60 times"),
          Text("Feeling awesome"),
        ],
      ),
    );
  }
}
