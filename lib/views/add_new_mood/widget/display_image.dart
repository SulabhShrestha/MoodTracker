import 'dart:io';

import 'package:flutter/material.dart';

class DisplayImage extends StatelessWidget {
  final double size;
  final String path;
  final VoidCallback callback;
  const DisplayImage(
      {Key? key,
      required this.size,
      required this.path,
      required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.file(
          File(path),
          width: size,
          fit: BoxFit.cover,
        ),
        Positioned(
          right: 12,
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
