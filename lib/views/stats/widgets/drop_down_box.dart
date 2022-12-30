import 'package:flutter/material.dart';

/// Responsible for displaying dropdownbox
///
class DropDownButton extends StatefulWidget {
  const DropDownButton({Key? key}) : super(key: key);

  @override
  State<DropDownButton> createState() => _DropDownButtonState();
}

class _DropDownButtonState extends State<DropDownButton> {
  String textToDisplay = "All time";

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: PopupMenuButton<String>(
        onSelected: (value) {
          setState(() {
            textToDisplay = value;
          });
        },
        itemBuilder: (context) {
          return [
            const PopupMenuItem(child: Text("All time"), value: "All time"),
            const PopupMenuItem(child: Text("Last week"), value: "Last week"),
            const PopupMenuItem(child: Text("Last month"), value: "Last month"),
            const PopupMenuItem(child: Text("Set date"), value: "Set date"),
          ];
        },
        child: Padding(
          padding: EdgeInsets.zero,
          child: FittedBox(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(textToDisplay),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
