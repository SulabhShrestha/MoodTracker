import 'package:flutter/material.dart';

class BorderedContainer extends StatelessWidget {
  final Widget child;
  const BorderedContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: child,
    );
  }
}
