import 'dart:developer';

import 'package:flutter/material.dart';

import '../views/core/highlight_text.dart';

enum KeywordPositionInText {
  first,
  last,
  inBetween;
}

/// Provides support to highlighting the text
///
class TextUtils {
  Widget returnText(
      {required String text,
      required String type,
      String? keyword,
      String? keywordIncludesIn}) {
    log("Return text: $keywordIncludesIn, $type, $keyword");

    return HighlightText(
      keyword: keyword ?? "",
      fullText: text,
      heading: type,
    );
  }
}
