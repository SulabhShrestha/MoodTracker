import 'package:flutter/material.dart';

// data for navigation bar
List<IconData> navIconData = [
  Icons.home,
  Icons.calendar_today,
  Icons.summarize_outlined
];
List<String> navValueData = ["Home", "Calendar", "Summary"];

// for hiding navigation bar
enum CurrentPage { search, other }
