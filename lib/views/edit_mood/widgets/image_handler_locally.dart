import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mood_tracker/view_models/mood_list_view_model.dart';
import 'package:mood_tracker/views/add_new_mood/utils/local_image.dart';
import 'package:mood_tracker/views/core/image_viewer.dart';

/// This widget works with remote connection only
///
/// Originally paths passed is convert to the url
class ImageHandlerLocally extends StatefulWidget {
  final List<dynamic> dbImagesPath;
  final String date;
  final int timestamp;
  final ValueChanged<Map<String, dynamic>>
      onChanged; // when ever the images is altered

  const ImageHandlerLocally({
    Key? key,
    required this.dbImagesPath,
    required this.date,
    required this.timestamp,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<ImageHandlerLocally> createState() => _ImageHandlerLocallyState();
}

class _ImageHandlerLocallyState extends State<ImageHandlerLocally> {
  double imageMinSize =
      200; // the size of the image when the user adds the image

  // To manage images locally we need to handle both dbImagePath and localImagePath;
  List<String> localImagesPath = []; // First it contains url and then other
  List<String> urlImagesPath =
      []; // It is not altered, and is used for checking if the path is url or not

  bool showLoading = true;

  // stores the [dbImagesPath]
  // Necessary as the images can be deleted, and only alive images URL is to be fetched
  List<dynamic> dbImagesPathTemp = [];

  @override
  void initState() {
    log("Again inside of initstate imageHandler locally");
    _fetchImageUrl();

    _handleImageDisplayingSize();
    super.initState();
  }

  void _handleImageDisplayingSize() {
    // handling length
    if (localImagesPath.length == 3) {
      imageMinSize = 180;
    } else if (localImagesPath.length == 4) {
      imageMinSize = 160;
    }
  }

  Future<void> _fetchImageUrl() async {
    await MoodListViewModel().getImagesURL(widget.dbImagesPath).then((value) {
      urlImagesPath = value;

      // Creating a new reference since list is of reference type
      // and the changes made to the [localImagesPath] reflects to [urlImagePath]
      localImagesPath = List<String>.from(urlImagesPath);

      setState(() {
        showLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoading) {
      return const CircularProgressIndicator();
    } else {
      // User may also not alter any images, so returning the urlPaths
      widget.onChanged({
        "urlImagesPath": urlImagesPath,
        "localImagesPath": localImagesPath,
      });
      return Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var path in localImagesPath)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: ImageViewer(
                      size: imageMinSize,
                      path: path,
                      isURL: urlImagesPath.contains(path),
                      callback: () {
                        // also removing from the [urlImagePath]
                        if (urlImagesPath.isNotEmpty) {
                          var index = localImagesPath.indexOf(path);
                          urlImagesPath.removeAt(index);
                        }

                        // removing the path from the list
                        setState(() {
                          localImagesPath.remove(path);
                        });
                        widget.onChanged({
                          "urlImagesPath": urlImagesPath,
                          "localImagesPath": localImagesPath,
                        });
                      },
                    ),
                  ),
              ],
            ),
          ),
          Visibility(
            visible: localImagesPath.length >= 4 ? false : true,
            child: Row(
              children: [
                // Camera
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      String? path = await LocalImage.pickImageFromCamera();

                      if (path != null) {
                        setState(() {
                          localImagesPath.add(path);

                          _handleImageDisplayingSize();
                        });
                        widget.onChanged({
                          "urlImagesPath": urlImagesPath,
                          "localImagesPath": localImagesPath,
                        });
                      }
                    },
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(const BorderSide()),
                    ),
                    child: const Text("From Camera"),
                  ),
                ),

                const SizedBox(width: 16),

                // Gallery
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      String? path = await LocalImage.pickImageFromGallery();

                      if (path != null) {
                        setState(() {
                          localImagesPath.add(path);

                          _handleImageDisplayingSize();
                        });
                        widget.onChanged({
                          "urlImagesPath": urlImagesPath,
                          "localImagesPath": localImagesPath,
                        });
                      }
                    },
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(const BorderSide()),
                    ),
                    child: const Text("From Gallery"),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}
