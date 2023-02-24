import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mood_tracker/view_models/mood_list_view_model.dart';
import 'package:mood_tracker/views/core/image_viewer.dart';

class ImageCollection extends StatefulWidget {
  final List<dynamic> dbImagesPath;
  final bool showImageDeleteBtn;
  final bool isRemoveImageRemotely;
  final String date;
  final int timestamp;
  const ImageCollection({
    Key? key,
    required this.dbImagesPath,
    this.showImageDeleteBtn = true,
    required this.date,
    required this.timestamp,
    this.isRemoveImageRemotely = false,
  }) : super(key: key);

  @override
  State<ImageCollection> createState() => _ImageCollectionState();
}

class _ImageCollectionState extends State<ImageCollection> {
  double imageMinSize =
      200; // the size of the image when the user adds the image

  List<String> imagesURL = [];
  bool showLoading = true;

  @override
  void initState() {
    if (widget.dbImagesPath.length == 3) {
      imageMinSize = 180;
    } else if (widget.dbImagesPath.length == 4) {
      imageMinSize = 160;
    }

    super.initState();
  }

  void removeImageLocally(String path) {
    setState(() {
      imagesURL.remove("");
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: MoodListViewModel().getImagesURL(widget.dbImagesPath),
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
                            if (widget.isRemoveImageRemotely) {
                              log("Before: ${widget.dbImagesPath}");
                              // Received snapshot is the url path.
                              // So, Getting the index of the path in the snapshot
                              int index = snapshot.data!.indexOf(path);

                              // Getting the db path using index
                              var imageDbPath = widget.dbImagesPath[index];

                              // removing the old storage path
                              widget.dbImagesPath.remove(imageDbPath);

                              log("DB path: ${widget.dbImagesPath}");
                              MoodListViewModel().deleteImageRemotely(
                                deletingImagePath: imageDbPath,
                                date: widget.date,
                                timestamp: widget.timestamp,
                                updatedImagesPath: widget.dbImagesPath,
                              );
                            } else {
                              removeImageLocally(path);
                            }
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
