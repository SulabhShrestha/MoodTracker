import 'package:flutter/material.dart';
import 'package:mood_tracker/views/add_new_mood/add_new_mood.dart';

import 'widgets/multi_item_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddNewMood()),
          );
        },
      ),
      body: const SafeArea(child: MultiItemCard()),
    );
  }
}
