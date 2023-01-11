import 'package:flutter/material.dart';
import 'package:mood_tracker/view_models/mood_list_view_model.dart';
import 'package:mood_tracker/views/stats/stats_page.dart';
import 'package:provider/provider.dart';

import 'calendar_page/calendar_page.dart';
import 'home_page/home_page.dart';

/// This page is the main page, that hols [HomePage], [Calendar] and [Stats] pages
///

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  // Storing list of pages
  final _pages = <Widget>[
    ChangeNotifierProvider(
        create: (BuildContext context) => MoodListViewModel(),
        child: HomePage()),
    const CalendarPage(),
    const StatsPage(),
  ];

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[index],
      bottomNavigationBar: Container(
        color: Colors.greenAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  index = 0;
                });
              },
              icon: Icon(Icons.book_outlined),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  index = 1;
                });
              },
              icon: Icon(Icons.calendar_today),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  index = 2;
                });
              },
              icon: Icon(Icons.query_stats),
            ),
          ],
        ),
      ),
    );
  }
}
