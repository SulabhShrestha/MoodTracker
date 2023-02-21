import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/emoji_utils.dart';

/// Responsible for display 5 emoji widget

class EmojiPanel extends StatefulWidget {
  final ValueChanged<int> onSelected;
  final int? previousRating; // if it is going to be edited

  const EmojiPanel({Key? key, required this.onSelected, this.previousRating})
      : super(key: key);

  @override
  State<EmojiPanel> createState() => _EmojiPanelState();
}

class _EmojiPanelState extends State<EmojiPanel> {
  int currentSelectedContainer = -1;

  @override
  void initState() {
    currentSelectedContainer = widget.previousRating ?? -1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double containerSize = (constraints.maxWidth / 6) - 4;
      return SizedBox(
        width: double.infinity,
        height: containerSize + 15,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: List.generate(
            5,
            (index) => GestureDetector(
              onTap: () {
                widget.onSelected(index);

                setState(() {
                  currentSelectedContainer = index;
                });
              },
              child: Container(
                width: index == currentSelectedContainer
                    ? containerSize + 10
                    : containerSize,
                height: index == currentSelectedContainer
                    ? containerSize + 10
                    : containerSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: index == currentSelectedContainer
                      ? Border.all(color: Colors.deepPurple, width: 3)
                      : null,
                ),
                child: SvgPicture.string(EmojiUtils.getSvgPath(index + 1)),
              ),
            ),
          ),
        ),
      );
    });
  }
}
