import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mood_tracker/models/time_stamp.dart';
import 'package:mood_tracker/views/home_page/widgets/multi_item_card.dart';

import '../add_new_mood/add_new_mood.dart';
import '../core/single_item_card.dart';
import 'widgets/popup_menu_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final moodListViewModel = Provider.of<MoodListViewModel>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddNewMood(
                // moodListViewModel: moodListViewModel,
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
        body: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collectionGroup('List').snapshots(),
          builder: (context, snapshot) {
            log("data: ${snapshot.hasData} && ${snapshot.connectionState}, ${snapshot.data?.docs}");

            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.active) {
              List<QueryDocumentSnapshot> listData =
                  snapshot.data!.docs.toList();

              // descending order
              listData.sort(
                  (a, b) => b.get("timestamp").compareTo(a.get("timestamp")));

              final groupedData =
                  <String, List<QueryDocumentSnapshot>>{}; // date: List

              for (var document in listData) {
                final date = document.get("date");
                if (!groupedData.containsKey(date)) {
                  groupedData[date] = [];
                }
                groupedData[date]?.add(document);
              }

              log("Grouped data: $groupedData");

              log("amount: ${groupedData.entries.length}");

              return ListView(
                children: List.generate(groupedData.entries.length, (index) {
                  log("Inside: ${groupedData.entries.elementAt(index)}");
                  List<QueryDocumentSnapshot> values =
                      groupedData.entries.elementAt(index).value;

                  if (values.length == 1) {
                    return SingleItemCard(
                      date: values.first.get("date"),
                      rating: values.first.get("rating"),
                      timeStamp: TimeStamp(values.first.get("timestamp")),
                      reason: values.first.get("why"),
                      feedback: values.first.get("feedback"),
                    );
                  }

                  // Means we have more than one mood in a single day
                  else {
                    List<String?> feedbacks = [];
                    List<int> ratings = [];
                    List<TimeStamp> timestamps = [];
                    List<String?> reasons = [];

                    for (var element in values) {
                      feedbacks.add(element.get("feedback"));
                      ratings.add(element.get("rating"));
                      timestamps.add(TimeStamp(element.get("timestamp")));
                      reasons.add(element.get("why"));
                    }

                    return MultiItemCard(
                      date: values.first.get("date"),
                      feedbacks: feedbacks,
                      ratings: ratings,
                      reasons: reasons,
                      timeStamps: timestamps,
                    );
                  }
                }),
              );
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
