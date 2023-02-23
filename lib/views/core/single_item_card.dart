import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mood_tracker/models/time_stamp.dart';

import '../../utils/emoji_utils.dart';
import '../home_page/widgets/bold_first_word_text.dart';
import '../home_page/widgets/image_collection.dart';
import 'edit_delete_card_item.dart';

/// This card is design to show only one mood

class SingleItemCard extends StatelessWidget {
  final String date;
  final int rating;
  final TimeStamp timeStamp;
  final bool showEditDeleteButton;
  final String? reason;
  final String? feedback;
  final List<dynamic> dbImagesPath;
  final bool showImageDeleteBtn;

  const SingleItemCard({
    Key? key,
    required this.date,
    required this.rating,
    required this.timeStamp,
    required this.dbImagesPath,
    this.showEditDeleteButton = true,
    this.showImageDeleteBtn = true,
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
        child: Column(
          children: [
            // Written
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Emoji
                SvgPicture.string(EmojiUtils.getSvgPath(rating),
                    width: 60, height: 60),

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
                if (showEditDeleteButton)
                  Expanded(
                    child: EditDeleteCardItem(
                      timestamp: timeStamp.timestamp,
                      date: date,
                      rating: rating,
                      reason: reason,
                      feedback: feedback,
                    ),
                  ),
              ],
            ),

            // Displaying images
            if (dbImagesPath.isNotEmpty)
              ImageCollection(
                dbImagesPath: dbImagesPath,
                showImageDeleteBtn: showImageDeleteBtn,
              ),
          ],
        ),
      ),
    );
  }
}
