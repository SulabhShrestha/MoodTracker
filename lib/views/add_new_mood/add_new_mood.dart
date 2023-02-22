import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mood_tracker/views/add_new_mood/utils/local_image.dart';
import 'package:mood_tracker/views/add_new_mood/widget/display_image.dart';

import '../../view_models/mood_list_view_model.dart';
import '../core/bordered_container.dart';
import '../core/emoji_panel.dart';
import 'utils.dart';

/// This is responsible for adding new mood to current date
///

class AddNewMood extends StatefulWidget {
  const AddNewMood({
    Key? key,
  }) : super(key: key);

  @override
  State<AddNewMood> createState() => _AddNewMoodState();
}

class _AddNewMoodState extends State<AddNewMood> {
  final _whyController = TextEditingController();

  final _feedbackController = TextEditingController();

  final moodListViewModel = MoodListViewModel();

  List<String?> imagesPath = [];
  double imageMinSize =
      200; // the size of the image when the user adds the image

  Future<void> addStuffs({required VoidCallback onComplete}) async {
    await moodListViewModel.addNewMoodDB(
      rating: rating,
      why: _whyController.text.trim(),
      feedback: _feedbackController.text.trim(),
      imagesPath: imagesPath,
    );

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
                await addStuffs(onComplete: () {
                  Navigator.pop(context);
                });
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
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

                  // Displaying images are selecting
                  LayoutBuilder(builder: (context, constraints) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          if (imagesPath.isNotEmpty)
                            for (var path in imagesPath)
                              Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: DisplayImage(
                                  size: math.max(
                                      constraints.maxWidth / imagesPath.length,
                                      imageMinSize),
                                  path: path!,
                                  callback: () {
                                    setState(() {
                                      imagesPath.remove(path);
                                    });
                                  },
                                ),
                              ),
                        ],
                      ),
                    );
                  }),

                  Visibility(
                    visible: imagesPath.length >= 4 ? false : true,
                    child: Row(
                      children: [
                        // Camera
                        Expanded(
                          child: TextButton(
                            onPressed: () async {
                              String? path =
                                  await LocalImage.pickImageFromCamera();
                              setState(() {
                                imagesPath.add(path);

                                if (imagesPath.length == 3) {
                                  imageMinSize = 180;
                                } else if (imagesPath.length == 4) {
                                  imageMinSize = 160;
                                }
                              });
                            },
                            style: ButtonStyle(
                              side:
                                  MaterialStateProperty.all(const BorderSide()),
                            ),
                            child: const Text("From Camera"),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Gallery
                        Expanded(
                          child: TextButton(
                            onPressed: () async {
                              String? path =
                                  await LocalImage.pickImageFromGallery();
                              setState(() {
                                imagesPath.add(path);

                                if (imagesPath.length == 3) {
                                  imageMinSize = 180;
                                } else if (imagesPath.length == 4) {
                                  imageMinSize = 160;
                                }
                              });
                            },
                            style: ButtonStyle(
                              side:
                                  MaterialStateProperty.all(const BorderSide()),
                            ),
                            child: const Text("From Gallery"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
