import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mood_tracker/view_models/mood_list_view_model.dart';
import 'package:mood_tracker/views/core/bordered_container.dart';

import '../core/emoji_panel.dart';

/// This is responsible for adding new mood to current date
///

class EditMood extends StatelessWidget {
  final String date;
  final int rating;
  final int timestamp;
  final MoodListViewModel moodListViewModel;

  final String? reason;
  final String? feedback;

  EditMood({
    Key? key,
    required this.date,
    required this.rating,
    required this.timestamp,
    required this.moodListViewModel,
    this.reason,
    this.feedback,
  }) : super(key: key) {
    newRating = rating;
  }

  var newRating = 0;
  final _whyController = TextEditingController();
  final _feedbackController = TextEditingController();

  Future<void> editStuffs({required VoidCallback onComplete}) async {
    var newReason = _whyController.text.trim();
    var newFeedback = _feedbackController.text.trim();

    await moodListViewModel.updateMoodDB(
      rating: newRating,
      timestamp: timestamp,
      date: date,
      why: newReason.isEmpty ? reason : newReason,
      feedback: newFeedback.isEmpty ? feedback : newFeedback,
    );
    log("EDIT: $newRating, $newReason,  $newFeedback");
    onComplete.call();
  }

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
            onPressed: () async {
              if (rating == 0) {
                debugPrint("Rating is necessary");
              } else {
                await editStuffs(onComplete: () {
                  Navigator.pop(context);
                });
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
                    newRating = index + 1;
                    log("New Rating: $newRating");
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
                  decoration: InputDecoration(
                    hintText: reason,
                    enabledBorder: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(),
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
                  decoration: InputDecoration(
                    hintText: feedback,
                    enabledBorder: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(),
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
