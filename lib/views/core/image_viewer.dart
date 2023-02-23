import 'dart:io';

import 'package:flutter/material.dart';

// Responsible for displaying list of images
class ImageViewer extends StatelessWidget {
  final double size;
  final String path;
  final VoidCallback callback;
  final bool isURL;
  final bool showImageDeleteBtn;
  const ImageViewer(
      {Key? key,
      required this.size,
      required this.path,
      required this.callback,
      required this.isURL,
      this.showImageDeleteBtn = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (!isURL)
          Image.file(
            File(path),
            width: size,
            fit: BoxFit.cover,
          ),
        if (isURL) Image.network(path, width: size, fit: BoxFit.cover),
        if (showImageDeleteBtn)
          Positioned(
            right: 0,
            child: Material(
              color: Colors.transparent,
              child: IconButton(
                onPressed: callback,
                splashRadius: 24,
                splashColor: Colors.white24,
                icon: const CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
      ],
    );
  }
}
