import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mood_tracker/models/time_stamp.dart';
import 'package:mood_tracker/utils/date_helper.dart';
import 'package:mood_tracker/view_models/user_view_model.dart';
import 'package:mood_tracker/views/drawer/home_drawer.dart';
import 'package:mood_tracker/views/home_page/widgets/get_user_name.dart';
import 'package:mood_tracker/views/home_page/widgets/multi_item_card.dart';
import 'package:mood_tracker/views/search_page/search_page.dart';
import 'package:provider/provider.dart';

import '../add_new_mood/add_new_mood.dart';
import '../core/single_item_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final username = FirebaseAuth.instance.currentUser?.displayName ?? "";
  late bool isDialogToShow;

  @override
  void initState() {
    isDialogToShow = username.isEmpty ? true : false;
    // FirebaseAuth.instance.currentUser?.updateDisplayName("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log("User: ${FirebaseAuth.instance.currentUser}");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddNewMood()));
        },
      ),
      drawer: const HomeDrawer(),
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (_, isScrolled) {
          return [
            SliverAppBar(
              floating: true,
              title: Consumer<UserViewModel>(
                builder: ((context, value, child) {
                  return Text(
                    "Hey, ${value.getUserName.split(" ").first}!",
                    style: const TextStyle(color: Colors.black),
                  );
                }),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SearchPage()));
                  },
                  icon: Icon(Icons.search),
                ),
              ],
            ),
          ];
        },
        body: Stack(
          children: [
            Builder(builder: (_) {
              if (username.isEmpty && isDialogToShow) {
                isDialogToShow = false;
                Future.delayed(
                    Duration.zero,
                    () => GetUserName().ask(
                          context: context,
                          userViewModel: context.read<UserViewModel>(),
                        ));
              }
              return Container();
            }),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collectionGroup('List')
                  .snapshots(),
              builder: (context, snapshot) {
                log("data: ${snapshot.hasData} && ${snapshot.connectionState}, ${snapshot.data?.docs}");

                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.active) {
                  List<QueryDocumentSnapshot> listData =
                      snapshot.data!.docs.toList();

                  // descending order
                  listData.sort((a, b) =>
                      b.get("timestamp").compareTo(a.get("timestamp")));

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
                    children:
                        List.generate(groupedData.entries.length, (index) {
                      List<QueryDocumentSnapshot> values =
                          groupedData.entries.elementAt(index).value;

                      // Labelling date {today, yesterday, tomorrow }
                      var dateLabel =
                          DateHelper().getDateLabel(values.first.get('date'));

                      log("DateHelpder: $dateLabel");

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

                          imagesStoragePaths.add(element.get('imagesPath'));
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

                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
