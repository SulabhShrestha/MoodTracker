import 'package:flutter/material.dart';
import 'package:mood_tracker/views/widgets/single_item_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: SingleItemCard()),
    );
  }
}
