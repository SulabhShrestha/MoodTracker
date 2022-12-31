import 'package:flutter/material.dart';
import 'package:mood_tracker/views/add_new_mood/add_new_mood.dart';
import 'package:mood_tracker/views/home_page/widgets/single_item_card.dart';

import 'widgets/multi_item_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddNewMood()),
          );
        },
      ),
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (_, isScrolled) {
          return [
            SliverAppBar(
              floating: true,
              title: const Text(
                "Hey, Sulabh!",
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                GestureDetector(
                  onTapDown: (details) async {
                    final position = details.globalPosition;
                    await showMenu(
                      color: Colors.white,
                      //add your color
                      context: context,
                      position:
                          RelativeRect.fromLTRB(position.dx, position.dy, 0, 0),
                      items: [
                        PopupMenuItem(
                          value: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0, right: 40),
                            child: Row(
                              children: [
                                Icon(Icons.mail_outline),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Menu 1",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          value: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0, right: 40),
                            child: Row(
                              children: [
                                Icon(Icons.vpn_key),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Menu 2",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          value: 3,
                          child: Row(
                            children: [
                              Icon(Icons.power_settings_new_sharp),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Menu 3",
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                  child: const Icon(
                    Icons.settings,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ];
        },
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: const [
            SingleItemCard(),
            MultiItemCard(),
          ],
        ),
      ),
    );
  }
}
