import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mood_tracker/utils/constant.dart';

/// Responsible for displaying a single image
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
            child: IconButton(
              onPressed: callback,
              splashRadius: 24,
              splashColor: Constant().colors.white,
              style: IconButton.styleFrom(
                splashFactory: InkRipple.splashFactory,
                backgroundColor: Constant().colors.darkRed,
                highlightColor: Constant().colors.green.withOpacity(0.6),
              ),
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          )
      ],
    );
  }
}
