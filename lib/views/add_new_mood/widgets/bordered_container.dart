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
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: child,
    );
  }
}
