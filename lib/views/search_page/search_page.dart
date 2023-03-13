import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mood_tracker/models/mood.dart';
import 'package:mood_tracker/models/time_stamp.dart';
import 'package:mood_tracker/utils/date_helper_utils.dart';
import 'package:mood_tracker/view_models/mood_list_view_model.dart';
import 'package:mood_tracker/views/core/single_item_card.dart';
import 'package:mood_tracker/views/home_page/widgets/multi_item_card.dart';

class SearchPage extends StatefulWidget {
  final VoidCallback onSearchExit;
  const SearchPage({super.key, required this.onSearchExit});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _textController = TextEditingController();
  String? keyword;
  GlobalKey<NavigatorState> mainParentNavigatorKey =
      GlobalKey<NavigatorState>();
  bool isSearchClicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
            widget.onSearchExit();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Search',
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    isSearchClicked = true;
                    setState(() => keyword = _textController.text.trim());
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue)),
                  child: const Text("Search",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder(
                  future: MoodListViewModel()
                      .searchMoodsByKeyword(searchKeyword: keyword),
                  builder: (context, snapshot) {
                    log("DATA: ${snapshot.data?.isEmpty}, ${snapshot.data}");
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData &&
                        snapshot.data!.isEmpty &&
                        isSearchClicked) {
                      return const Text("Nothing to display.");
                    } else if (snapshot.data!.isEmpty && !isSearchClicked) {
                      return const SizedBox();
                    }
                    return Navigator(
                      key: mainParentNavigatorKey,
                      onGenerateRoute: (settings) =>
                          MaterialPageRoute(builder: (context) {
                        return ListView(
                          children: List.generate(snapshot.data!.entries.length,
                              (index) {
                            List<Mood> values =
                                snapshot.data!.entries.elementAt(index).value;

                            // after deleting [localResultMoods] may looks like this
                            // 'date": [], so no further process after this
                            if (values.isEmpty) {
                              return const Text("Nothing to display");
                            }

                            // Labelling date {today, yesterday, tomorrow }
                            var dateLabel = DateHelperUtils()
                                .getDateLabel(values.first.date);

                            if (values.length == 1) {
                              return SingleItemCard(
                                date: values.first.date,
                                dateLabel: dateLabel,
                                rating: values.first.rating,
                                timeStamp: values.first.timestamp,
                                reason: values.first.why,
                                feedback: values.first.feedback,
                                dbImagesPath: values.first.imagesPath,
                                keywordIncludesIn:
                                    values.first.keywordIncludesIn,
                                keyword: keyword,
                                mainParentNavigatorKey: mainParentNavigatorKey,
                                additionalDeleteAction: () {
                                  setState(() {
                                    // deleting from [localResultMoods] using index position
                                    snapshot.data![values.first.date]!
                                        .removeAt(index);
                                  });
                                },
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

                              // For highlighting texts
                              List<String?> keywordsIncludesIn = [];

                              // Combining all the data
                              for (var element in values) {
                                feedbacks.add(element.feedback);
                                ratings.add(element.rating);
                                timestamps.add(element.timestamp);
                                reasons.add(element.why);

                                imagesStoragePaths.add(element.imagesPath);
                                keywordsIncludesIn
                                    .add(element.keywordIncludesIn);
                              }

                              return MultiItemCard(
                                date: values.first.date,
                                dateLabel: dateLabel,
                                feedbacks: feedbacks,
                                ratings: ratings,
                                reasons: reasons,
                                timeStamps: timestamps,
                                imagesStoragePaths: imagesStoragePaths,
                                keyword: keyword,
                                keywordsIncludesIn: keywordsIncludesIn,
                                mainParentNavigatorKey: mainParentNavigatorKey,
                                additionalDeleteAction: (timestamp) {
                                  setState(() {
                                    // deleting from [localResultMoods] using timestamp which is unique
                                    // [timestamp] is passed from [MultiItemCard]
                                    snapshot.data![values.first.date]
                                        ?.removeWhere((mood) =>
                                            mood.timestamp.timestamp ==
                                            timestamp);
                                  });
                                },
                              );
                            }
                          }),
                        );
                      }),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
