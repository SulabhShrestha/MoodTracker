import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker/providers/week_first_day_provider.dart';

class FirstDaySelection extends ConsumerWidget {
  final Function(String) onChanged;

  const FirstDaySelection({Key? key, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String firstDay = ref.read(weekFirstDayProvider);
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile(
            title: const Text('Auto'),
            value: "Auto",
            groupValue: firstDay,
            onChanged: (value) {
              Navigator.of(context).pop();
              onChanged(value!);
            },
          ),
          RadioListTile(
            title: const Text('Sunday'),
            value: "Sunday",
            groupValue: firstDay,
            onChanged: (value) {
              Navigator.of(context).pop();
              onChanged(value!);
            },
          ),
          RadioListTile(
            title: const Text('Monday'),
            value: "Monday",
            groupValue: firstDay,
            onChanged: (value) {
              Navigator.of(context).pop();
              onChanged(value!);
            },
          ),
          RadioListTile(
            title: const Text('Saturday'),
            value: "Saturday",
            groupValue: firstDay,
            onChanged: (value) {
              Navigator.of(context).pop();
              onChanged(value!);
            },
          ),
        ],
      ),
    );
  }
}
