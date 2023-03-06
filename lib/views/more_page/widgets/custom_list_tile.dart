import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final IconData leadingIconData;
  final VoidCallback? onTap;

  const CustomListTile({
    Key? key,
    required this.title,
    required this.leadingIconData,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      leading: Icon(
        leadingIconData,
        size: 28,
      ),
      trailing: const Icon(Icons.navigate_next_outlined),
      dense: true,
      contentPadding: EdgeInsets.zero,
    );
  }
}
