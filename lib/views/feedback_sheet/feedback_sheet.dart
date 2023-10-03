import 'package:flutter/material.dart';

import 'widget/feedback_options.dart';

class FeedbackSheet extends StatelessWidget {
  const FeedbackSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Header part
          Row(
            children: <Widget>[
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
                padding: EdgeInsets.zero,
                alignment: Alignment.center,
              ),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 32.0),
                  child: Text(
                    "Send feedback to TheDev",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),

          // Main Part
          const FeedbackOptions(),
        ],
      ),
    );
  }
}
