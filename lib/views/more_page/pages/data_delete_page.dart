import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker/providers/homepage_key_provider.dart';
import 'package:mood_tracker/utils/constant.dart';
import 'package:mood_tracker/view_models/user_view_model.dart';
import 'package:mood_tracker/views/continue_with_page/continue_with.dart';
import 'package:mood_tracker/views/core/delete_confirmation_dialog.dart';
import 'package:mood_tracker/views/more_page/widgets/custom_box.dart';
import 'package:mood_tracker/views/more_page/widgets/custom_list_tile.dart';

class DataDeletePage extends ConsumerWidget {
  DataDeletePage({super.key});

  final dataDeletePageKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

                          await UserViewModel().deleteUser().then((val){
                            // First dialog, and then DataDeletePage
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(ref.read(homePageKeyProvider).currentContext!).pushReplacement(MaterialPageRoute(builder: (context) => const ContinueWithPage()));

                          }).onError((error, stackTrace) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Something went wrong")));
                          });


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
                          }).onError((error, stackTrace){
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Something went wrong")));
                          });
                          Navigator.of(context).pop();
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
