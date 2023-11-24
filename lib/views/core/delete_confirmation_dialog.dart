import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mood_tracker/utils/constant.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final Future<void> Function() onConfirm;
  final Widget? content;

  const DeleteConfirmationDialog(
      {Key? key, this.content, required this.onConfirm})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Deletion'),
      content: content ?? const Text('Are you sure you want to delete?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            backgroundColor: Constant().colors.white,
            foregroundColor: Constant().colors.primary,
          ),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            onConfirm();
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
