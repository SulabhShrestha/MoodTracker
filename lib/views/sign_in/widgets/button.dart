import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const Button({
    Key? key,
    required this.child,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: ButtonStyle(
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
