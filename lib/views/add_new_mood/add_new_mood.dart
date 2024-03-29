import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mood_tracker/utils/constant.dart';
import 'package:mood_tracker/utils/pop_up.dart';
import 'package:mood_tracker/views/add_new_mood/utils/local_image.dart';
import 'package:mood_tracker/views/core/image_viewer.dart';
import 'package:mood_tracker/views/core/required_field.dart';

import '../../view_models/mood_list_view_model.dart';
import '../core/bordered_container.dart';
import '../core/emoji_panel.dart';
import 'utils.dart';

/// This is responsible for adding new mood to current date
///

class AddNewMood extends StatefulWidget {
  const AddNewMood({
    super.key,
  });

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

  bool isAdding = false; // for loading indicator when mood is added

  Future<void> addStuffs({required VoidCallback onComplete}) async {
    setState(() => isAdding = true);
    await moodListViewModel.addNewMoodDB(
      rating: rating,
      why: _whyController.text.trim(),
      feedback: _feedbackController.text.trim(),
      imagesPath: imagesPath,
    );

    onComplete.call();
    setState(() => isAdding = false);
  }

  Widget _actionIcon() {
    if (isAdding) {
      return const Padding(
        padding: EdgeInsets.all(12.0),
        child: CircularProgressIndicator(
          color: Colors.amberAccent,
          strokeWidth: 2,
        ),
      );
    } else {
      return IconButton(
        icon: const Icon(Icons.check),
        onPressed: () async {
          if (rating == 0) {
            showSnackBar(context, "Rating not selected.");
          } else {
            await addStuffs(onComplete: () {
              Navigator.pop(context);
            });
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_outlined),
        ),
        actions: [_actionIcon()],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              BorderedContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const RequiredField(),
                    EmojiPanel(
                      onSelected: (index) {
                        rating = index + 1;
                        log(rating.toString());
                      },
                    ),
                  ],
                ),
              ),
              Constant().spaces.vertical12(),
              BorderedContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Why did you feel this way?",
                      style: TextStyle(fontSize: 20),
                    ),
                    TextField(
                      controller: _whyController,
                    ),
                  ],
                ),
              ),
              Constant().spaces.vertical12(),
              BorderedContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "What could go better?",
                      style: TextStyle(fontSize: 20),
                    ),
                    TextField(
                      controller: _feedbackController,
                    ),
                  ],
                ),
              ),
              Constant().spaces.vertical12(),
              BorderedContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Images",
                      style: TextStyle(fontSize: 20),
                    ),

                    // Displaying images that are selected
                    Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            if (imagesPath.isNotEmpty)
                              for (var path in imagesPath)
                                Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: ImageViewer(
                                    size: imageMinSize,
                                    path: path!,
                                    isURL: false,
                                    callback: () {
                                      setState(() {
                                        imagesPath.remove(path);
                                      });
                                    },
                                  ),
                                ),
                          ],
                        ),
                      ),
                    ),

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

                                if (path != null) {
                                  setState(() {
                                    imagesPath.add(path);

                                    if (imagesPath.length == 3) {
                                      imageMinSize = 180;
                                    } else if (imagesPath.length == 4) {
                                      imageMinSize = 160;
                                    }
                                  });
                                }
                              },
                              style: ButtonStyle(
                                side: MaterialStateProperty.all(
                                    const BorderSide()),
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

                                if (path != null) {
                                  setState(() {
                                    imagesPath.add(path);

                                    if (imagesPath.length == 3) {
                                      imageMinSize = 180;
                                    } else if (imagesPath.length == 4) {
                                      imageMinSize = 160;
                                    }
                                  });
                                }
                              },
                              style: ButtonStyle(
                                side: MaterialStateProperty.all(
                                    const BorderSide()),
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
      ),
    );
  }
}
