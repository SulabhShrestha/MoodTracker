import 'package:flutter/material.dart';

class ButtonForPopUpMenuItem extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String text;

  const ButtonForPopUpMenuItem({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon),
          Text(
            text,
            style: const TextStyle(color: Colors.black),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
