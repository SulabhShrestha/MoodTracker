import 'package:flutter/material.dart';
import 'package:mood_tracker/view_models/user_view_model.dart';

class RequiredField extends StatelessWidget {
  const RequiredField({super.key});

  @override
  Widget build(BuildContext context) {
    var username = UserViewModel().getUserName.split(" ").first;
    return Row(
      children: [
        RichText(
          text: TextSpan(
            text: 'How was your day ',
            style: DefaultTextStyle.of(context).style.copyWith(fontSize: 20),
            children: <TextSpan>[
              TextSpan(
                text: username,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(
                text: '?',
              ),
            ],
          ),
        ),
        const Text(
          " *",
          style: TextStyle(color: Colors.red),
        ),
      ],
    );
  }
}
