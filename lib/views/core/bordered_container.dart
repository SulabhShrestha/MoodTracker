import 'package:flutter/material.dart';

/// This creates bordered container
///

class BorderedContainer extends StatelessWidget {
  final Widget child;
  const BorderedContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}
