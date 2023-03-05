import 'package:flutter/material.dart';
import 'package:mood_tracker/view_models/email_view_model.dart';

class FeedbackOptions extends StatelessWidget {
  const FeedbackOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main part
        const Text("What type of feedback you would like to share?"),

        // feedback selection
        Row(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1 / 0.9,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: const BorderRadius.all(Radius.circular(24)),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      await EmailViewModel().openEmailClient("Reporting issue");
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(Icons.flag_circle),
                        Text("Report an issue"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 24,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1 / 0.9,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: const BorderRadius.all(Radius.circular(24)),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      await EmailViewModel().openEmailClient("App suggestion");
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(Icons.lightbulb_circle),
                        Text("Make a suggestion"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
