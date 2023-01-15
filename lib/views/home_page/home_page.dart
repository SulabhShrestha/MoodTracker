import 'package:flutter/material.dart';
import 'package:mood_tracker/view_models/mood_list_view_model.dart';
import 'package:mood_tracker/views/add_new_mood/add_new_mood.dart';
import 'package:mood_tracker/views/home_page/widgets/multi_item_card.dart';
import 'package:mood_tracker/views/home_page/widgets/single_item_card.dart';
import 'package:provider/provider.dart';

import '../../models/time_stamp.dart';
import '../../view_models/mood_view_model.dart';
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
            builder: (context) => AddNewMood(
              moodListViewModel: moodListViewModel,
            ),
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
          children:
              List.generate(moodListViewModel.moods.entries.length, (index) {
            List<MoodViewModel> values =
                moodListViewModel.moods.entries.elementAt(index).value;
            if (values.length == 1) {
              return SingleItemCard(
                date: values.first.date,
                rating: values.first.rating,
                timestamp: values.first.timestamp,
                reason: values.first.reason,
                feedback: values.first.feedback,
              );
            }

            // Means we have more than one mood in a single day
            else {
              List<String?> feedbacks = [];
              List<int> ratings = [];
              List<TimeStamp> timestamps = [];
              List<String?> reasons = [];

              for (var element in values) {
                feedbacks.add(element.feedback);
                ratings.add(element.rating);
                timestamps.add(element.timestamp);
                reasons.add(element.reason);
              }

              return MultiItemCard(
                date: values.first.date,
                feedbacks: feedbacks,
                ratings: ratings,
                reasons: reasons,
                timestamps: timestamps,
              );
            }
          }),
        ),
      ),
    );
  }
}
