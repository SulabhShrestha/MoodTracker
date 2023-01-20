import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mood_tracker/view_models/mood_list_view_model.dart';
import 'package:provider/provider.dart';

class EditDeleteCardItem extends StatelessWidget {
  final int timestamp;
  final String date;

  const EditDeleteCardItem(
      {Key? key, required this.timestamp, required this.date})
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
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: const Text('Edit'),
                onTap: () {
                  log("Timestamp: $timestamp");
                },
              ),
              PopupMenuItem(
                child: const Text('Delete'),
                onTap: () {
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
