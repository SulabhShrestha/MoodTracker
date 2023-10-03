import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker/providers/homepage_key_provider.dart';
import 'package:mood_tracker/view_models/mood_list_view_model.dart';
import 'package:mood_tracker/views/core/delete_confirmation_dialog.dart';

import '../edit_mood/edit_mood.dart';

class EditDeleteCardItem extends ConsumerWidget {
  final String date;
  final int rating;
  final int timestamp;
  final List<dynamic> dbImagesPath;
  final String? reason;
  final String? feedback;
  final VoidCallback? additionalDeleteAction;
  final VoidCallback?
      customEditAction; // for displaying edit page over search page

  const EditDeleteCardItem({
    Key? key,
    required this.timestamp,
    required this.date,
    required this.rating,
    required this.dbImagesPath,
    this.reason,
    this.feedback,
    this.additionalDeleteAction,
    this.customEditAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
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
                onTap: () async {
                  if (customEditAction != null) {
                    customEditAction!.call();
                  } else {
                    await Future.delayed(
                        const Duration(seconds: 0),
                        () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => EditMood(
                                  rating: rating,
                                  date: date,
                                  timestamp: timestamp,
                                  reason: reason,
                                  feedback: feedback,
                                  dbImagesPath: dbImagesPath,
                                ))));
                  }
                },
              ),
              PopupMenuItem(
                child: const Text('Delete'),
                onTap: () {
                  final parentContext =
                      ref.watch(homePageKeyProvider).currentContext;

                  log("Deleting: ${ref.watch(homePageKeyProvider).currentContext}");

                  if (parentContext != null) {
                    showDialog(
                      context: parentContext,
                      builder: (_) => DeleteConfirmationDialog(
                        onConfirm: () async {
                          additionalDeleteAction?.call();
                          MoodListViewModel()
                              .deleteMood(timestamp: timestamp, date: date);
                        },
                      ),
                    );
                  }
                },
              ),
            ];
          },
        ),
      ],
    );
  }
}
