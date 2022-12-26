import 'package:flutter/material.dart';
import 'package:mood_tracker/views/add_new_mood/widgets/bordered_container.dart';

/// This is responsible for adding new mood to current date
///

class AddNewMood extends StatelessWidget {
  const AddNewMood({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          BorderedContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("How was your day?"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    5,
                    (index) => const CircleAvatar(),
                  ),
                ),
              ],
            ),
          ),
          BorderedContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Why did you feel this way?"),
                TextField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          BorderedContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("What could go better?"),
                TextField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          BorderedContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Photo"),
                Center(
                  child: TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(const BorderSide()),
                    ),
                    child: const Text("Add a photo"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
