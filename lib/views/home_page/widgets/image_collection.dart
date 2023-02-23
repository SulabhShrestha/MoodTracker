import 'package:flutter/material.dart';
import 'package:mood_tracker/view_models/mood_list_view_model.dart';
import 'package:mood_tracker/views/core/image_viewer.dart';

class ImageCollection extends StatefulWidget {
  final List<dynamic> dbImagesPath;
  const ImageCollection({Key? key, required this.dbImagesPath})
      : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
                          callback: () {
                            setState(() {
                              imagesURL.remove(path);
                            });
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
