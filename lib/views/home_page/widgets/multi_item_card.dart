import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../models/time_stamp.dart';
import '../../../utils/emoji_utils.dart';
import '../../core/edit_delete_card_item.dart';
import 'bold_first_word_text.dart';
import 'image_collection.dart';

/// This card is design to show more than one mood

class MultiItemCard extends StatelessWidget {
  final String date;
  final String dateLabel;
  final List<String?> feedbacks;
  final List<int> ratings;
  final List<TimeStamp> timeStamps;
  final List<String?> reasons;
  final List<List<dynamic>> imagesStoragePaths;

  const MultiItemCard({
    Key? key,
    required this.date,
    required this.dateLabel,
    required this.feedbacks,
    required this.ratings,
    required this.timeStamps,
    required this.reasons,
    required this.imagesStoragePaths,
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
              child: Text("$dateLabel, $date"),
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
                        SvgPicture.string(
                            Uri.decodeFull(
                                EmojiUtils.getSvgPath(ratings[index])),
                            width: 60,
                            height: 60),

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
                          rating: ratings[index],
                          feedback: feedbacks[index],
                          reason: reasons[index],
                        )),
                      ],
                    ),

                    // Displaying images
                    if (imagesStoragePaths[index].isNotEmpty)
                      ImageCollection(
                        dbImagesPath: imagesStoragePaths[index],
                        isRemoveImageRemotely: true,
                        date: date,
                        timestamp: timeStamps[index].timestamp,
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
