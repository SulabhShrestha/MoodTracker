import 'package:flutter/material.dart';

/// Responsible for displaying dropdownbox
///
class DropDownButton extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String text;
  const DropDownButton({Key? key, required this.onChanged, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: PopupMenuButton<String>(
        onSelected: onChanged,
        itemBuilder: (context) {
          return [
            const PopupMenuItem(value: "All time", child: Text("All time")),
            const PopupMenuItem(value: "This month", child: Text("This month")),
            const PopupMenuItem(value: "Set date", child: Text("Set date")),
          ];
        },
        child: Padding(
          padding: EdgeInsets.zero,
          child: FittedBox(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(text),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
