import 'package:flutter/material.dart';
import 'package:mood_tracker/views/add_new_mood/add_new_mood.dart';
import 'package:mood_tracker/views/home_page/widgets/single_item_card.dart';

import 'widgets/multi_item_card.dart';
import 'widgets/popup_menu_list.dart';

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
            const SliverAppBar(
              floating: true,
              title: Text(
                "Hey, Sulabh!",
                style: TextStyle(color: Colors.black),
              ),
              actions: [PopUpMenuList()],
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
