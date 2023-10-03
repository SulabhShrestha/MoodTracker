import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mood_tracker/utils/constant.dart';
import 'package:mood_tracker/view_models/user_view_model.dart';
import 'package:mood_tracker/views/core/delete_confirmation_dialog.dart';
import 'package:mood_tracker/views/more_page/widgets/custom_box.dart';
import 'package:mood_tracker/views/more_page/widgets/custom_list_tile.dart';

class DataDeletePage extends StatelessWidget {
  const DataDeletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delete my data"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          children: [
            CustomBox(
              child: Column(children: [
                CustomListTile(
                  title: "Delete my account",
                  leadingIconData: Icons.account_box,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => DeleteConfirmationDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Are you sure you want to delete your account?",
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Warning: This will delete all your existing data and cannot be undone.",
                              style: TextStyle(
                                color: Constant().colors.red,
                              ),
                            ),
                          ],
                        ),
                        onConfirm: () async {
                          await UserViewModel().deleteUser();
                        },
                      ),
                    );
                  },
                ),
              ]),
            ),
            Constant().spaces.vertical12(),
            CustomBox(
              child: Column(children: [
                CustomListTile(
                  title: "Delete my data",
                  leadingIconData: Icons.share_outlined,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => DeleteConfirmationDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Are you sure you want to delete your data?",
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Warning: This will delete all your existing data, account and cannot be undone.",
                              style: TextStyle(
                                color: Constant().colors.red,
                              ),
                            ),
                          ],
                        ),
                        onConfirm: () async {
                          UserViewModel().deleteUserData().then((val) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Deleted successfully")));
                          });
                        },
                      ),
                    );
                  },
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
