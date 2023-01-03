import 'package:flutter/material.dart';

import 'widgets/bordered_container.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

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
                  children: [
                    CircleAvatar(),
                    Column(
                      children: [
                        Text("Sulabh Shrestha"),
                        Text("abc@gmail.com"),
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
