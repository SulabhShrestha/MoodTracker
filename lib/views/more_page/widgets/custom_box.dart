import 'package:flutter/material.dart';

/// Creates box having border radius of 10
///
/// This is mainly used in user profile screen

class CustomBox extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const CustomBox({Key? key, required this.child, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: child,
    );
  }
}
