import 'package:flutter/material.dart';

class HighlightText extends StatelessWidget {
  final String fullText;
  final String keyword;
  final String heading; // I could have, Because

  const HighlightText({
    Key? key,
    required this.fullText,
    required this.keyword,
    required this.heading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RegExp regExp = RegExp(keyword, caseSensitive: false);
    List<TextSpan> textSpans = [];

    textSpans.add(TextSpan(
        text: "$heading ",
        style: const TextStyle(fontWeight: FontWeight.bold)));

    int currentIndex = 0;
    while (true) {
      if (keyword.isEmpty) {
        // If the search string is empty, add the entire text with the default style
        textSpans.add(TextSpan(text: fullText));
        break;
      }

      // Find the next match of the search string in the text
      Match? match = regExp.firstMatch(fullText.substring(currentIndex));
      if (match == null) {
        // If there are no more matches, add the remaining text to the textSpans
        textSpans.add(TextSpan(text: fullText.substring(currentIndex)));
        break;
      }

      // Add the text before the match to the textSpans
      if (match.start > 0) {
        textSpans.add(TextSpan(
            text:
                fullText.substring(currentIndex, currentIndex + match.start)));
      }

      // Add the matched text to the textSpans with the highlightStyle
      textSpans.add(
        TextSpan(
            text: match.group(0),
            style: TextStyle(background: Paint()..color = Colors.yellow)),
      );

      // Update the currentIndex to after the match for the next iteration
      currentIndex += match.start + match.group(0)!.length;

      // Skip the next occurrence of the search string if it immediately follows the current match
      while (regExp.hasMatch(fullText.substring(currentIndex))) {
        Match nextMatch = regExp.firstMatch(fullText.substring(currentIndex))!;
        if (nextMatch.start == 0) {
          // If the next match starts at the same position as the current match, skip it
          currentIndex += nextMatch.group(0)!.length;
        } else {
          // If the next match doesn't immediately follow the current match, break out of the loop
          break;
        }
      }
    }

    var rt = RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: textSpans,
      ),
    );

    return rt;
  }
}
