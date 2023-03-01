import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mood_tracker/utils/text_utils.dart';

class HighlightText extends StatelessWidget {
  final String keyword;
  final String fullText;
  final String boldWord;

  const HighlightText({
    Key? key,
    required this.keyword,
    required this.fullText,
    required this.boldWord,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textKeywordDetails =
        TextUtils().getTextKeywordDetails(keyword: keyword, fullText: fullText);

    log("Inside of highlighting $textKeywordDetails");

    // Don't know why RichText is not working
    if (textKeywordDetails["keywordPositionInText"] ==
        KeywordPositionInText.first) {
      return Row(
        children: [
          Text("$boldWord: ",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text("${textKeywordDetails["firstPhase"]} ",
              style: const TextStyle(decoration: TextDecoration.underline)),
          Text(textKeywordDetails["lastPhase"].toString()),
        ],
      );
    } else if (textKeywordDetails["keywordPositionInText"] ==
        KeywordPositionInText.last) {
      return Row(
        children: [
          Text("$boldWord: ",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text("${textKeywordDetails["firstPhase"]} "),
          Text(textKeywordDetails["lastPhase"].toString(),
              style: const TextStyle(decoration: TextDecoration.underline)),
        ],
      );
    } else {
      return Row(
        children: [
          Text("$boldWord: ",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text("${textKeywordDetails["firstPhase"]} "),
          Text(textKeywordDetails["middlePhase"].toString(),
              style: const TextStyle(decoration: TextDecoration.underline)),
          Text(" ${textKeywordDetails["lastPhase"]}"),
        ],
      );
    }
  }
}
