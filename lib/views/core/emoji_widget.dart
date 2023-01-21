import 'package:flutter/material.dart';

class EmogiWidget extends StatefulWidget {
  final double? height;
  final double? width;

  const EmogiWidget({
    Key? key,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  State<EmogiWidget> createState() => _EmogiWidgetState();
}

class _EmogiWidgetState extends State<EmogiWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: widget.height,
      width: widget.width,
      duration: const Duration(milliseconds: 200),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red,
      ),
    );
  }
}
