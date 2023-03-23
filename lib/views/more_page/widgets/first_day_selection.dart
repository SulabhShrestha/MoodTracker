import 'package:flutter/material.dart';
import 'package:mood_tracker/models/first_day_of_week_model.dart';

class FirstDaySelection extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const FirstDaySelection({Key? key, required this.onChanged})
      : super(key: key);

  @override
  State<FirstDaySelection> createState() => _FirstDaySelectionState();
}

class _FirstDaySelectionState extends State<FirstDaySelection> {
  var currentSelectedOption = "Auto";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirstDayOfWeekModel()
            .getFirstDayOfWeek(), // No need of provider here
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Text("Something went wrong.");
          }

          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile(
                  title: const Text('Auto'),
                  value: "Auto",
                  groupValue: snapshot.data!,
                  onChanged: (value) {
                    setState(() => currentSelectedOption = value!);
                    widget.onChanged(value!);
                  },
                ),
                RadioListTile(
                  title: const Text('Sunday'),
                  value: "Sunday",
                  groupValue: snapshot.data!,
                  onChanged: (value) {
                    setState(() => currentSelectedOption = value!);
                    widget.onChanged(value!);
                  },
                ),
                RadioListTile(
                  title: const Text('Monday'),
                  value: "Monday",
                  groupValue: snapshot.data!,
                  onChanged: (value) {
                    setState(() => currentSelectedOption = value!);
                    widget.onChanged(value!);
                  },
                ),
                RadioListTile(
                  title: const Text('Saturday'),
                  value: "Saturday",
                  groupValue: snapshot.data!,
                  onChanged: (value) {
                    setState(() => currentSelectedOption = value!);
                    widget.onChanged(value!);
                  },
                ),
              ],
            ),
          );
        });
  }
}
