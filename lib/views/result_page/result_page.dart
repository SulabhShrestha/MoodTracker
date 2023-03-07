import 'package:flutter/material.dart';
import 'package:mood_tracker/models/mood.dart';
import 'package:mood_tracker/models/time_stamp.dart';
import 'package:mood_tracker/utils/date_helper_utils.dart';
import 'package:mood_tracker/views/core/single_item_card.dart';

import '../home_page/widgets/multi_item_card.dart';

class ResultPage extends StatefulWidget {
  final Map<String, List<Mood>> resultMoods;
  final String keyword;

  const ResultPage({
    Key? key,
    required this.resultMoods,
    required this.keyword,
  }) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  var localResultMoods = {};

  @override
  void initState() {
    localResultMoods = widget.resultMoods;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.keyword),
      ),
      body: ListView(
        children: List.generate(localResultMoods.entries.length, (index) {
          List<Mood> values = localResultMoods.entries.elementAt(index).value;

          // after deleting [localResultMoods] may looks like this
          // 'date": [], so no further process after this
          if (values.isEmpty) {
            return const Text("Nothing to display");
          }

          // Labelling date {today, yesterday, tomorrow }
          var dateLabel = DateHelperUtils().getDateLabel(values.first.date);

          if (values.length == 1) {
            return SingleItemCard(
              date: values.first.date,
              dateLabel: dateLabel,
              rating: values.first.rating,
              timeStamp: values.first.timestamp,
              reason: values.first.why,
              feedback: values.first.feedback,
              dbImagesPath: values.first.imagesPath,
              keywordIncludesIn: values.first.keywordIncludesIn,
              keyword: widget.keyword,
              additionalDeleteAction: () {
                setState(() {
                  // deleting from [localResultMoods] using index position
                  localResultMoods[values.first.date].removeAt(index);
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
              keywordsIncludesIn.add(element.keywordIncludesIn);
            }

            return MultiItemCard(
              date: values.first.date,
              dateLabel: dateLabel,
              feedbacks: feedbacks,
              ratings: ratings,
              reasons: reasons,
              timeStamps: timestamps,
              imagesStoragePaths: imagesStoragePaths,
              keyword: widget.keyword,
              keywordsIncludesIn: keywordsIncludesIn,
              additionalDeleteAction: (timestamp) {
                setState(() {
                  // deleting from [localResultMoods] using timestamp which is unique
                  // [timestamp] is passed from [MultiItemCard]
                  localResultMoods[values.first.date]?.removeWhere(
                      (mood) => mood.timestamp.timestamp == timestamp);
                });
              },
            );
          }
        }),
      ),
    );
  }
}
