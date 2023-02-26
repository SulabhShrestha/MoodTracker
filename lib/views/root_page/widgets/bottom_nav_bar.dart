import 'package:flutter/material.dart';
import 'package:mood_tracker/views/root_page/widgets/nav_item.dart';

import '../utils/nav_utils.dart';

/// Provides bottom nav bar with 3 items
/// Items can be edited in [nav_utils.dart]
///
class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  var currentlySelectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(border: Border.all()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(3, (index) {
          return NavItem(
            index: index,
            iconData: navIconData[index],
            value: navValueData[index],
            isSelected: index == currentlySelectedIndex,
            onClick: (value) {
              setState(() {
                currentlySelectedIndex = value;
              });
            },
          );
        }),
      ),
    );
  }
}
