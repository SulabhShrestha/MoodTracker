import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mood_tracker/view_models/mood_list_view_model.dart';
import 'package:mood_tracker/views/core/bordered_container.dart';
import 'package:mood_tracker/views/edit_mood/widgets/image_handler_locally.dart';

import '../core/emoji_panel.dart';

/// This is responsible for adding new mood to current date
///

class EditMood extends StatefulWidget {
  final String date;
  final int rating;
  final int timestamp;
  final List<dynamic> dbImagesPath;
  final String? reason;
  final String? feedback;

  const EditMood({
    Key? key,
    required this.date,
    required this.rating,
    required this.timestamp,
    required this.dbImagesPath,
    this.reason,
    this.feedback,
  }) : super(key: key);

  @override
  State<EditMood> createState() => _EditMoodState();
}

class _EditMoodState extends State<EditMood> {
  final _whyController = TextEditingController();

  final _feedbackController = TextEditingController();

  double imageMinSize =
      200; // the size of the image when the user adds the image

  var rating = 0;
  Map<String, dynamic> editedPaths = {}; // Mixture of local and

  Future<void> editStuffs({required VoidCallback onComplete}) async {
    var newReason = _whyController.text.trim();
    var newFeedback = _feedbackController.text.trim();

    // getting any difference to the url paths
    var beforeImagesUrlPath =
        await MoodListViewModel().getImagesURL(widget.dbImagesPath);

    // if [afterImagesUrlPath] < [beforeImagesUrlPath], user has deleted something
    List<String> afterImagesUrlPath = editedPaths["urlImagesPath"];

    // what is to be deleted
    List<String> urlDifference = beforeImagesUrlPath
        .where((element) => !afterImagesUrlPath.contains(element))
        .toList();

    log("Any difference: $urlDifference");

    // what images I want to store, contains path of images of database
    List<String> updatedImagesStoragePath = [];

    // contains the paths of images that user wants to delete
    List<String> deletingImagesPaths = [];

    // getting database storagePath of images that the user wants to save
    if (afterImagesUrlPath.isNotEmpty) {
      for (var url in afterImagesUrlPath) {
        var storagePath = Uri.parse(url).pathSegments.last;
        updatedImagesStoragePath.add(storagePath);
      }
    }

    // Getting the database path from the url
    if (urlDifference.isNotEmpty) {
      for (var url in urlDifference) {
        // Getting the storage path
        var path = Uri.parse(url).pathSegments.last;
        deletingImagesPaths.add(path);
      }
      await MoodListViewModel().deleteImages(
        deletingImagePaths: deletingImagesPaths,
        date: widget.date,
        timestamp: widget.timestamp,
        updatedImagesPath: updatedImagesStoragePath,
      );
    }

    await MoodListViewModel().updateMoodDB(
      rating: rating,
      timestamp: widget.timestamp,
      date: widget.date,
      why: newReason.isEmpty ? widget.reason : newReason,
      feedback: newFeedback.isEmpty ? widget.feedback : newFeedback,
    );
    onComplete.call();
  }

  @override
  void initState() {
    rating = widget.rating;
    if (widget.dbImagesPath.length == 3) {
      imageMinSize = 180;
    } else if (widget.dbImagesPath.length == 4) {
      imageMinSize = 160;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
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
                  previousRating: widget.rating - 1,
                  onSelected: (index) {
                    rating = index + 1;
                    log("New Rating: $rating");
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
                    hintText: widget.reason,
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
                    hintText: widget.feedback,
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

                // Displaying images are selecting
                ImageHandlerLocally(
                  dbImagesPath: widget.dbImagesPath,
                  timestamp: widget.timestamp,
                  date: widget.date,
                  onChanged: (value) {
                    editedPaths = value;

                    log("EditedPaths: $editedPaths");
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
