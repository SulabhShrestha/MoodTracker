import 'package:flutter/material.dart';
import 'package:mood_tracker/views/sign_in_page/sign_in.dart';
import 'package:mood_tracker/views/sign_up_page/sign_up.dart';

/// This widget is used in [SignInPage] and [SignUpPage] only

class Button extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  final Color? backgroundColor;

  const Button({
    Key? key,
    required this.child,
    required this.onTap,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(backgroundColor),
        shape: MaterialStateProperty.all(
          const ContinuousRectangleBorder(
            side: BorderSide(),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      child: child,
    );
  }
}
