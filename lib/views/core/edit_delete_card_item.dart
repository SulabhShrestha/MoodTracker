import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mood_tracker/view_models/mood_list_view_model.dart';
import 'package:provider/provider.dart';

import '../edit_mood/edit_mood.dart';

class EditDeleteCardItem extends StatelessWidget {
  final String date;
  final int rating;
  final int timestamp;

  final String? reason;
  final String? feedback;

  const EditDeleteCardItem(
      {Key? key,
      required this.timestamp,
      required this.date,
      required this.rating,
      this.reason,
      this.feedback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moodListViewModel = Provider.of<MoodListViewModel>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        PopupMenuButton(
          shape: const OutlineInputBorder(),
          position: PopupMenuPosition.under,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey,
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.more_vert,
              color: Colors.grey,
            ),
          ),
          itemBuilder: (parentContext) {
            return [
              PopupMenuItem(
                child: const Text('Edit'),
                onTap: () async {
                  Future.delayed(
                      const Duration(seconds: 0),
                      () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => EditMood(
                                rating: rating,
                                date: date,
                                timestamp: timestamp,
                                reason: reason,
                                feedback: feedback,
                                moodListViewModel: moodListViewModel,
                              ))));
                },
              ),
              PopupMenuItem(
                child: const Text('Delete'),
                onTap: () {
                  log("I am to be deleting $timestamp");
                  moodListViewModel.deleteMood(
                      timestamp: timestamp, date: date);
                },
              ),
            ];
          },
        ),
      ],
    );
  }
}
