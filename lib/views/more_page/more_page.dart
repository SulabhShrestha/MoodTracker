import 'package:flutter/material.dart';
import 'package:mood_tracker/view_models/auth_view_model.dart';
import 'package:mood_tracker/view_models/email_view_model.dart';
import 'package:mood_tracker/view_models/share_view_model.dart';
import 'package:mood_tracker/view_models/user_view_model.dart';

import '../feedback_sheet/feedback_sheet.dart';
import 'widgets/custom_box.dart';
import 'widgets/custom_list_tile.dart';

/// Responsible for displaying drawer in the homepage
///

class MorePage extends StatelessWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userViewModel = UserViewModel();
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          children: <Widget>[
            // User image, name, number
            CustomBox(
              child: Row(
                children: [
                  CircleAvatar(
                    maxRadius: 36,
                    backgroundImage: NetworkImage(userViewModel.getPhotoURL),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userViewModel.getUserName),
                      Text(userViewModel.getEmail),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            // Other
            CustomBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  CustomListTile(
                    title: "Send feedback",
                    leadingIconData: Icons.feedback,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => const FeedbackSheet(),
                      );
                    },
                  ),
                  CustomListTile(
                    title: "Tell your friends",
                    leadingIconData: Icons.share_outlined,
                    onTap: () {
                      ShareViewModel().shareApp();
                    },
                  ),
                  const CustomListTile(
                    title: "Rate us",
                    leadingIconData: Icons.star_outlined,
                  ),
                  CustomListTile(
                    title: "Contact us",
                    leadingIconData: Icons.email_outlined,
                    onTap: () {
                      EmailViewModel().openEmailClient("Let's connect");
                    },
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () async {
                await AuthViewModel().signOut();
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red)),
              child: const Text(
                "Log out",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
