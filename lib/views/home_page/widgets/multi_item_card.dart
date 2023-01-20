import 'package:flutter/material.dart';

import '../../../models/time_stamp.dart';
import '../../core/edit_delete_card_item.dart';
import 'bold_first_word_text.dart';

/// This card is design to show more than one mood

class MultiItemCard extends StatelessWidget {
  final String date;
  final List<String?> feedbacks;
  final List<int> ratings;
  final List<TimeStamp> timeStamps;
  final List<String?> reasons;

  const MultiItemCard({
    Key? key,
    required this.date,
    required this.feedbacks,
    required this.ratings,
    required this.timeStamps,
    required this.reasons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: const RoundedRectangleBorder(
        side: BorderSide(),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Date
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.greenAccent,
              child: Text("Today, $date"),
            ),

            Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(ratings.length, (index) {
                return Column(
                  children: [
                    // Item one
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Emoji
                        Image.network(
                          "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.pinimg.com%2Foriginals%2F17%2Fe8%2Fc1%2F17e8c10cbad011079e3c25b960e9c8a1.png&f=1&nofb=1&ipt=54fb33cf9ac23bcba5da9a777450f84a592ca60dfd4896deab2bd6a85b5f34aa&ipo=images",
                          height: 60,
                          width: 60,
                        ),

                        // Description
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BoldFirstWordText(
                                boldWord: "Amazing ",
                                normalWord: timeStamps[index].toHumanFormat,
                              ),
                              BoldFirstWordText(
                                boldWord: "Because ",
                                normalWord: reasons[index] ?? "",
                              ),
                              BoldFirstWordText(
                                  boldWord: "I could have ",
                                  normalWord: feedbacks[index] ?? ""),
                            ],
                          ),
                        ),

                        // editing and deleting option
                        Expanded(
                            child: EditDeleteCardItem(
                          timestamp: timeStamps[index].timestamp,
                          date: date,
                        )),
                      ],
                    ),

                    if (index + 1 == ratings.length)
                      const SizedBox()
                    else
                      const Divider(
                        color: Colors.green,
                      ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
