import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mood_tracker/view_models/mood_list_view_model.dart';
import 'package:mood_tracker/views/core/delete_confirmation_dialog.dart';
import 'package:mood_tracker/views/core/image_viewer.dart';

/// This widget works with remote connection only
class ImageCollectionRemotely extends StatefulWidget {
  final List<dynamic> dbImagesPath;
  final bool showImageDeleteBtn;
  final String date;
  final int timestamp;

  const ImageCollectionRemotely({
    Key? key,
    required this.dbImagesPath,
    required this.date,
    required this.timestamp,
    this.showImageDeleteBtn = true,
  }) : super(key: key);

  @override
  State<ImageCollectionRemotely> createState() =>
      _ImageCollectionRemotelyState();
}

class _ImageCollectionRemotelyState extends State<ImageCollectionRemotely> {
  double imageMinSize =
      200; // the size of the image when the user adds the image

  bool showLoading = true;
  List<dynamic> dbImagesPath = [];

  @override
  void initState() {
    dbImagesPath = widget.dbImagesPath;

    if (dbImagesPath.length == 3) {
      imageMinSize = 180;
    } else if (dbImagesPath.length == 4) {
      imageMinSize = 160;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: MoodListViewModel().getImagesURL(dbImagesPath),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return LayoutBuilder(builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var path in snapshot.data!)
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: ImageViewer(
                          size: imageMinSize,
                          path: path,
                          isURL: true,
                          showImageDeleteBtn: widget.showImageDeleteBtn,
                          callback: () {
                            showDialog(
                              context: context,
                              builder: (_) =>
                                  DeleteConfirmationDialog(onConfirm: () async {
                                log("Before: $dbImagesPath");
                                // Received snapshot is the url path.
                                // So, Getting the index of the path in the snapshot
                                int index = snapshot.data!.indexOf(path);

                                // Getting the db path using index
                                var imageDbPath = dbImagesPath[index];

                                // removing the path from the list and sending the updated again to the db
                                setState(() {
                                  dbImagesPath.remove(imageDbPath);
                                });

                                MoodListViewModel().deleteImages(
                                  deletingImagePaths: [
                                    imageDbPath
                                  ], // since imageDbPath is a single string
                                  date: widget.date,
                                  timestamp: widget.timestamp,
                                  updatedImagesPath: dbImagesPath,
                                );
                              }),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              );
            });
          } else if (snapshot.hasError) {
            return const Text("Something went wrong",
                style: TextStyle(color: Colors.red, fontSize: 20));
          }
          return const CircularProgressIndicator();
        });
  }
}
