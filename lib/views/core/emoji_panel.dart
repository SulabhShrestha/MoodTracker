import 'package:flutter/material.dart';

/// Responsible for display 5 emoji widget

class EmojiPanel extends StatelessWidget {
  final ValueChanged<int> onSelected;

  const EmojiPanel({Key? key, required this.onSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double containerSize = constraints.maxWidth / 6;
        return SizedBox(
          width: double.infinity,
          height: containerSize,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: List.generate(
              5,
              (index) => GestureDetector(
                onTap: () {
                  onSelected(index);
                },
                child: Container(
                    width: containerSize,
                    height: containerSize,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    )),
              ),
            ),
          ),
        );
      },
    );
  }
}
