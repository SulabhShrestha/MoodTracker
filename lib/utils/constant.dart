import 'package:flutter/material.dart';

class Constant {
  final colors = _Colors();
  final spaces = _Spaces();
}

class _Colors {
  Color primary = const Color(0xFF050000);
  Color secondary = const Color(0xFFA89F9F);
  Color yellow = const Color(0xFFE4C34E);
  Color red = const Color(0xFFf69291);
  Color green = const Color(0xFF21CA94);
  Color blue = const Color(0xFF3AB8EB);
  Color white = const Color(0xFFFFFFFF);
  Color pink = const Color(0xFFe7bbcf);
  Color orange = const Color(0xffeca060);
  Color purple = const Color(0xffc18cc7);

  Color darkRed = const Color(0xFFed742e);
}

class _Spaces {
  SizedBox vertical8() => const SizedBox(height: 8);
  SizedBox vertical12() => const SizedBox(height: 12);
  SizedBox vertical16() => const SizedBox(height: 16);
  SizedBox vertical20() => const SizedBox(height: 20);
  SizedBox vertical24() => const SizedBox(height: 24);
}
