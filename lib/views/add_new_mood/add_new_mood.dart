import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mood_tracker/bloc/bottom_navbar_bloc.dart';
import 'package:mood_tracker/utils/pop_up.dart';
import 'package:mood_tracker/views/add_new_mood/utils/local_image.dart';
import 'package:mood_tracker/views/core/image_viewer.dart';
import 'package:mood_tracker/views/root_page/root_page.dart';
import 'package:provider/provider.dart';

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

  static Future<bool> handleBackButton(BuildContext context) async {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return true;
    } else {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => const RootPage()));
      // Handle back button press in the home page or exit the app
      return false;
    }
  }
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

  _actionIcon() {
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
              Provider.of<BottomNavBarBloc>(context, listen: false)
                  .counterSink
                  .add(true);
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
          icon: const Icon(Icons.close),
          onPressed: () {
            Provider.of<BottomNavBarBloc>(context, listen: false)
                .counterSink
                .add(true);
            Navigator.pop(context);
          },
        ),
        actions: [_actionIcon()],
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return Future.value(
              false); // Prevent default behavior (closing the app)
        },
        child: SingleChildScrollView(
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
