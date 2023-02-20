import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mood_tracker/extension/string_ext.dart';

import '../../../view_models/user_view_model.dart';

/// If the username is null, this will pop on.

class GetUserName {
  Future<void> ask(
      {required BuildContext context,
      required UserViewModel userViewModel}) async {
    final nameController = TextEditingController();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('Sorry for the interruption'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Please provide your full name to continue'),
                TextField(
                  controller: nameController,
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    log("updating");
                    userViewModel
                        .updateUserName(nameController.text.capitalize)
                        .then((value) {
                      Navigator.of(context).pop();
                    });
                  } else {
                    debugPrint("Your name is empty");
                  }
                },
              ),
            ],
          );
        });
  }
}
