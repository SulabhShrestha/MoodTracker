import 'package:flutter/material.dart';
import 'package:mood_tracker/view_models/mood_list_view_model.dart';
import 'package:mood_tracker/views/add_new_mood/add_new_mood.dart';
import 'package:mood_tracker/views/home_page/widgets/single_item_card.dart';
import 'package:provider/provider.dart';

import 'widgets/popup_menu_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Provider.of<MoodListViewModel>(context, listen: false).fetchAllMoods();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final moodListViewModel = Provider.of<MoodListViewModel>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                AddNewMood(moodListViewModel: moodListViewModel),
          ));
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
        body: ListView(
          children: List.generate(moodListViewModel.moods.length,
              (index) => const SingleItemCard()),
        ),
      ),
    );
  }
}
