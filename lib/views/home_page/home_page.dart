import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker/models/time_stamp.dart';
import 'package:mood_tracker/view_models/mood_list_view_model.dart';
import 'package:mood_tracker/view_models/user_view_model.dart';
import 'package:mood_tracker/views/add_new_mood/add_new_mood.dart';
import 'package:mood_tracker/views/home_page/widgets/multi_item_card.dart';
import 'package:mood_tracker/views/search_page/search_page.dart';

import '../../utils/date_helper_utils.dart';
import '../core/single_item_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Content
        NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (_, isScrolled) {
            return [
              SliverAppBar(
                floating: true,
                title: Text(
                  "Hey! ${UserViewModel().getUserName.split(" ").first}",
                  style: const TextStyle(color: Colors.black),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      // hiding nav bar
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SearchPage()));
                    },
                    icon: const Icon(Icons.search),
                  ),
                ],
              ),
            ];
          },
          body: StreamBuilder<QuerySnapshot>(
            stream: MoodListViewModel().moodsStream,
            builder: (context, snapshot) {
              log("data: ${snapshot.hasData} && ${snapshot.connectionState}, ${snapshot.data?.docs}");

              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.active) {
                List<QueryDocumentSnapshot> listData =
                    snapshot.data!.docs.toList();

                final groupedData =
                    <String, List<QueryDocumentSnapshot>>{}; // date: List

                for (var document in listData) {
                  final date = document.get("date");
                  if (!groupedData.containsKey(date)) {
                    groupedData[date] = [];
                  }
                  groupedData[date]?.add(document);
                }

                return ListView(
                  children: List.generate(groupedData.entries.length, (index) {
                    List<QueryDocumentSnapshot> values =
                        groupedData.entries.elementAt(index).value;

                    // Labelling date {today, yesterday, tomorrow }
                    var dateLabel = DateHelperUtils()
                        .getDateLabel(values.first.get('date'));

                    if (values.length == 1) {
                      return SingleItemCard(
                        date: values.first.get("date"),
                        dateLabel: dateLabel,
                        rating: values.first.get("rating"),
                        timeStamp: TimeStamp(values.first.get("timestamp")),
                        reason: values.first.get("why"),
                        feedback: values.first.get("feedback"),
                        dbImagesPath: values.first.get("imagesPath"),
                      );
                    }

                    // Means we have more than one mood in a single day
                    else {
                      List<String?> feedbacks = [];
                      List<int> ratings = [];
                      List<TimeStamp> timestamps = [];
                      List<String?> reasons = [];
                      List<List<dynamic>> imagesStoragePaths =
                          []; // List of array of paths

                      // Combining all the data
                      for (var element in values) {
                        feedbacks.add(element.get("feedback"));
                        ratings.add(element.get("rating"));
                        timestamps.add(TimeStamp(element.get("timestamp")));
                        reasons.add(element.get("why"));

                        var imagesPath = element.get("imagesPath");

                        imagesStoragePaths.add(imagesPath);
                      }

                      return MultiItemCard(
                        date: values.first.get("date"),
                        dateLabel: dateLabel,
                        feedbacks: feedbacks,
                        ratings: ratings,
                        reasons: reasons,
                        timeStamps: timestamps,
                        imagesStoragePaths: imagesStoragePaths,
                      );
                    }
                  }),
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),

        // Navigate to [AddNewMood] page when click
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddNewMood()),
              );
            },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
