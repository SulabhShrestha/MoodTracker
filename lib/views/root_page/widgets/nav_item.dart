import 'package:flutter/material.dart';

class NavItem extends StatelessWidget {
  final int index;
  final IconData iconData;
  final String value;
  final ValueChanged<int> onClick;
  final bool isSelected;
  const NavItem({
    Key? key,
    required this.index,
    required this.iconData,
    required this.value,
    required this.onClick,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClick(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 4000),
        child: Row(
          children: [
            Icon(iconData),
            if (isSelected) Text(value),
          ],
        ),
      ),
    );
  }
}
