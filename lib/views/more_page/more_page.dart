import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker/providers/week_first_day_provider.dart';
import 'package:mood_tracker/view_models/auth_view_model.dart';
import 'package:mood_tracker/view_models/email_view_model.dart';
import 'package:mood_tracker/view_models/share_view_model.dart';
import 'package:mood_tracker/view_models/user_view_model.dart';
import 'package:mood_tracker/view_models/week_first_day_view_model.dart';
import 'package:mood_tracker/views/continue_with_page/continue_with.dart';
import 'package:mood_tracker/views/more_page/pages/data_delete_page.dart';
import 'package:mood_tracker/views/more_page/widgets/first_day_selection.dart';

import '../feedback_sheet/feedback_sheet.dart';
import 'pages/policy_web_view.dart';
import 'widgets/custom_box.dart';
import 'widgets/custom_list_tile.dart';

/// Responsible for displaying drawer in the homepage
///

class MorePage extends ConsumerStatefulWidget {
  const MorePage({super.key});

  @override
  ConsumerState<MorePage> createState() => _MorePageState();
}

class _MorePageState extends ConsumerState<MorePage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final userViewModel = UserViewModel();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.black),
        ),
      ),
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

            CustomBox(
              child: CustomListTile(
                title: "Delete data",
                leadingIconData: Icons.delete_forever,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DataDeletePage(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            CustomBox(
              child: CustomListTile(
                title: "Start of the week",
                leadingIconData: Icons.calendar_today,
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return FirstDaySelection(
                          onChanged: (day) async {
                            await WeekFirstDayViewModel()
                                .saveFirstDayOfWeek(day);
                            ref.read(weekFirstDayProvider.notifier).state = day;
                          },
                        );
                      });
                },
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
                    leadingIconData: Icons.feedback_outlined,
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
                  CustomListTile(
                    title: "Rate us",
                    leadingIconData: Icons.star_outlined,
                    onTap: () {
                      ShareViewModel().rateApp();
                    },
                  ),
                  CustomListTile(
                    title: "Contact us",
                    leadingIconData: Icons.email_outlined,
                    onTap: () {
                      EmailViewModel().openEmailClient("Let's connect");
                    },
                  ),
                  CustomListTile(
                    title: "Privacy Policy",
                    leadingIconData: Icons.privacy_tip,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const PolicyWebView(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                await AuthViewModel().signOut().then((value) {
                  setState(() => isLoading = false);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const ContinueWithPage()));
                });
              },
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Log out"),
            ),
          ],
        ),
      ),
    );
  }
}
