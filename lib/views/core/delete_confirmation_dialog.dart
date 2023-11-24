import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mood_tracker/utils/constant.dart';

class DeleteConfirmationDialog extends StatefulWidget {
  final Future<void> Function() onConfirm;
  final Widget? content;

  const DeleteConfirmationDialog(
      {super.key, this.content, required this.onConfirm});

  @override
  State<DeleteConfirmationDialog> createState() => _DeleteConfirmationDialogState();
}

class _DeleteConfirmationDialogState extends State<DeleteConfirmationDialog> {

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Deletion'),
      content: widget.content ?? const Text('Are you sure you want to delete?'),
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
          onPressed: () async{
            setState(() =>
              isLoading = true
            );
            await widget.onConfirm();

            setState(() => isLoading = false);
          },
          child: isLoading? const CircularProgressIndicator(): const Text('Delete'),
        ),
      ],
    );
  }
}
