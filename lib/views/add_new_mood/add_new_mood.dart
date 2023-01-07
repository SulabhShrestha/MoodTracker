import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mood_tracker/view_models/mood_list_view_model.dart';

import 'widgets/bordered_container.dart';
import 'widgets/emoji_panel.dart';

/// This is responsible for adding new mood to current date
///

class AddNewMood extends StatelessWidget {
  AddNewMood({Key? key}) : super(key: key);

  final _whyController = TextEditingController();
  final _feedbackController = TextEditingController();
  int rating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (rating == 0) {
                debugPrint("Rating is necessary");
              } else {
                MoodListViewModel().addNewMood(
                    rating: rating,
                    why: _whyController.text.trim(),
                    feedback: _feedbackController.text.trim());
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          BorderedContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("How was your day?"),
                EmojiPanel(
                  onSelected: (index) {
                    rating = index + 1;
                    log(rating.toString());
                  },
                ),
              ],
            ),
          ),
          BorderedContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Why did you feel this way?"),
                TextField(
                  controller: _whyController,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          BorderedContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("What could go better?"),
                TextField(
                  controller: _feedbackController,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          BorderedContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Photo"),
                Center(
                  child: TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(const BorderSide()),
                    ),
                    child: const Text("Add a photo"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
