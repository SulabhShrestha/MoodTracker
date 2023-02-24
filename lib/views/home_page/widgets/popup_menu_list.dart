import 'package:flutter/material.dart';

import '../../profile_page/profile_page.dart';
import 'button_for_pop_up_menu_item.dart';

class PopUpMenuList extends StatelessWidget {
  const PopUpMenuList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) async {
        final position = details.globalPosition;
        await showMenu(
          color: Colors.white,
          //add your color
          context: context,
          position: RelativeRect.fromLTRB(position.dx, position.dy, 0, 0),
          items: [
            PopupMenuItem(
              value: 1,
              child: ButtonForPopUpMenuItem(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => ProfilePage()),
                  );
                },
                icon: Icons.person,
                text: "Profile",
              ),
            ),
          ],
        );
      },
      child: const Icon(
        Icons.settings,
        color: Colors.black,
      ),
    );
  }
}
