import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mood_tracker/views/home_page/widgets/bold_first_word_text.dart';

import '../views/core/highlight_text.dart';

enum KeywordPositionInText {
  first,
  last,
  inBetween;
}

/// Provides support to highlighting the text
///
class TextUtils {
  Map<String, dynamic> getTextKeywordDetails(
      {required String keyword, required String fullText}) {
    List<String> originalTextList = fullText.split(" ");
    List<String> duplicateTextList = fullText.toLowerCase().split(" ");

    var keywordIndex = duplicateTextList.indexOf(keyword);

    var keywordPositionInText = (keywordIndex == 0)
        ? KeywordPositionInText.first
        : ((keywordIndex == (duplicateTextList.length - 1))
            ? KeywordPositionInText.last
            : KeywordPositionInText.inBetween);

    // If position is first -> [firstPhase] = keyword, [lastPhase] = rest;
    // If position is last -> [firstPhase] = rest, [lastPhase] = keyword;
    // If position is inBetween -> [firstPhase] = after, [middlePhase]=keyword [lastPhase] = before;
    var firstPhase = "", middlePhase = '', lastPhase = '';

    // first
    if (keywordIndex == 0) {
      firstPhase = keyword;
      originalTextList.removeAt(0);

      lastPhase = originalTextList.join(" ");
    }

    // last
    else if (keywordIndex == (duplicateTextList.length - 1)) {
      lastPhase = keyword;
      originalTextList.removeAt(duplicateTextList.length - 1);

      firstPhase = originalTextList.join(" ");
    }

    // inBetween
    else {
      middlePhase = keyword;

      firstPhase = originalTextList.getRange(0, keywordIndex).join(" ");
      lastPhase = originalTextList
          .getRange(keywordIndex + 1, duplicateTextList.length)
          .join(" ");
    }

    Map<String, dynamic> details = {
      "index": keywordIndex,
      "keywordPositionInText": keywordPositionInText,
      "firstPhase": firstPhase,
      "middlePhase": middlePhase,
      "lastPhase": lastPhase,
      "keyword": keyword,
    };
    return details;
  }

  Widget returnText(
      {required String text,
      required String type,
      String? keyword,
      String? keywordIncludesIn}) {
    log("Return text: $keywordIncludesIn, $type, $keyword");

    // Because
    if (type == "Because" && keyword != "none") {
      if (keywordIncludesIn == "why") {
        log("Going for hightlight");
        return HighlightText(keyword: keyword!, fullText: text, boldWord: type);
      }
      log("Going for bold");
      return BoldFirstWordText(boldWord: type, normalWord: text);
    }

    // I could have
    else {
      if (keywordIncludesIn == "feedback" && keyword != "none") {
        log("Going for highlight");

        return HighlightText(keyword: keyword!, fullText: text, boldWord: type);
      }
      log("Going for bold, $keywordIncludesIn");
      return BoldFirstWordText(boldWord: type, normalWord: text);
    }
  }
}
