import 'package:flutter/material.dart';
import 'package:mood_tracker/models/time_stamp.dart';

import '../home_page/widgets/bold_first_word_text.dart';
import 'edit_delete_card_item.dart';

/// This card is design to show only one mood

class SingleItemCard extends StatelessWidget {
  final String date;
  final int rating;
  final TimeStamp timeStamp;
  final String? reason;
  final String? feedback;

  const SingleItemCard({
    Key? key,
    required this.date,
    required this.rating,
    required this.timeStamp,
    this.reason,
    this.feedback,
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
        child: Row(
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
                  Text("Today, $date"),
                  BoldFirstWordText(
                    boldWord: "Amazing ",
                    normalWord: timeStamp.toHumanFormat,
                  ),
                  BoldFirstWordText(
                    boldWord: "Because ",
                    normalWord: reason ?? "",
                  ),
                  BoldFirstWordText(
                    boldWord: "I could have ",
                    normalWord: feedback ?? "",
                  ),
                ],
              ),
            ),

            // editing and deleting option
            Expanded(
                child: EditDeleteCardItem(
              timestamp: timeStamp.timestamp,
              date: date,
            )),
          ],
        ),
      ),
    );
  }
}
