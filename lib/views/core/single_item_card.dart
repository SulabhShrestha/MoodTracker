import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mood_tracker/models/time_stamp.dart';
import 'package:mood_tracker/utils/text_utils.dart';

import '../../utils/emoji_utils.dart';
import '../home_page/widgets/image_collection_remotely.dart';
import 'bold_first_word_text.dart';
import 'edit_delete_card_item.dart';

/// This card is design to show only one mood
class SingleItemCard extends StatelessWidget {
  final String date;
  final int rating;
  final TimeStamp timeStamp;
  final String dateLabel; // Today, Yesterday or DayName
  final List<dynamic> dbImagesPath;
  final bool showEditDeleteButton; // For deleting card
  final bool showImageDeleteBtn;
  final String? keywordIncludesIn;
  final String? keyword;
  final String? reason;
  final String? feedback;
  final VoidCallback?
      additionalDeleteAction; // for deleting mood from result page

  const SingleItemCard({
    Key? key,
    required this.date,
    required this.rating,
    required this.timeStamp,
    required this.dbImagesPath,
    required this.dateLabel,
    this.showEditDeleteButton = true,
    this.showImageDeleteBtn = true,
    this.keywordIncludesIn = "none",
    this.keyword,
    this.reason,
    this.feedback,
    this.additionalDeleteAction,
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Written
            Row(
              children: [
                SvgPicture.string(EmojiUtils.getSvgPath(rating),
                    width: 60, height: 60),

                // Description
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("$dateLabel, $date"),
                        BoldFirstWordText(
                          boldWord: "${EmojiUtils.getEmotion(rating)} ",
                          normalWord: timeStamp.toHumanFormat,
                        ),
                        if (reason?.isNotEmpty ==
                            true) // if '==' is not provided then it gives error
                          TextUtils().returnText(
                              type: "Because",
                              text: reason ?? "",
                              keyword: keyword,
                              keywordIncludesIn: keywordIncludesIn),
                        if (feedback?.isNotEmpty == true)
                          TextUtils().returnText(
                              text: feedback ?? "",
                              type: "I could have",
                              keyword: keyword,
                              keywordIncludesIn: keywordIncludesIn)
                      ],
                    ),
                  ),
                ),

                // editing and deleting option
                if (showEditDeleteButton)
                  EditDeleteCardItem(
                    timestamp: timeStamp.timestamp,
                    date: date,
                    rating: rating,
                    reason: reason,
                    feedback: feedback,
                    dbImagesPath: dbImagesPath,
                    additionalDeleteAction: additionalDeleteAction,
                  ),
              ],
            ),

            // Displaying images
            if (dbImagesPath.isNotEmpty)
              ImageCollectionRemotely(
                dbImagesPath: dbImagesPath,
                showImageDeleteBtn: showImageDeleteBtn,
                date: date,
                timestamp: timeStamp.timestamp,
              ),
          ],
        ),
      ),
    );
  }
}
