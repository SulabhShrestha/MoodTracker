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
        tooltip: "Filter displaying result",
        position: PopupMenuPosition.under,
        padding: const EdgeInsets.all(16),
        onSelected: onChanged,
        itemBuilder: (context) {
          return ["All time", "This month", "This week", "Set date"]
              .map((value) {
            return PopupMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
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
