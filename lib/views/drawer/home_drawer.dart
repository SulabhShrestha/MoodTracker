import 'package:flutter/material.dart';
import 'package:mood_tracker/view_models/auth_view_model.dart';
import 'package:mood_tracker/view_models/user_view_model.dart';

/// Responsible for displaying drawer in the homepage
///

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userViewModel = UserViewModel();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(userViewModel.getUserName),
            accountEmail: Text(userViewModel.getEmail),
            currentAccountPicture: userViewModel.getPhotoURL.isNotEmpty
                ? CircleAvatar(
                    backgroundImage: NetworkImage(userViewModel.getPhotoURL))
                : CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(userViewModel.firstLetters),
                  ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.feedback),
            title: const Text('Send feedback'),
            onTap: () {},
          ),
          const Divider(
            height: 4,
            color: Colors.black,
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
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
    );
  }
}
