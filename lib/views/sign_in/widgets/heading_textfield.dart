import 'package:flutter/material.dart';

class HeadingTextField extends StatelessWidget {
  final String heading;
  final TextEditingController? controller;
  final bool obscureText;

  const HeadingTextField({
    Key? key,
    required this.heading,
    required this.obscureText,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(heading),
        TextField(
          obscureText: obscureText,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          ),
        ),
      ],
    );
  }
}
