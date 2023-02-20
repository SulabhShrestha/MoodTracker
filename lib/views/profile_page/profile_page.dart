import 'package:flutter/material.dart';

import '../../view_models/user_view_model.dart';
import 'widgets/bordered_container.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  final _userViewModel = UserViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
          child: Column(
            children: [
              BorderedContainer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(),
                      ),
                      child: _userViewModel.getPhotoURL.isNotEmpty
                          ? CircleAvatar(
                              backgroundImage:
                                  NetworkImage(_userViewModel.getPhotoURL))
                          : const CircleAvatar(
                              child: Icon(Icons.face, size: 50)),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_userViewModel.getUserName),
                        Text(_userViewModel.getEmail ?? ""),
                      ],
                    ),
                  ],
                ),
              ),
              ListTile(
                onTap: () {},
                title: Text("Change email"),
              ),
              ListTile(
                onTap: () {},
                title: Text("Change password"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
