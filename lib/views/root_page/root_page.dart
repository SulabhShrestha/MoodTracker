import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mood_tracker/view_models/stats_list_view_model.dart';
import 'package:mood_tracker/view_models/user_view_model.dart';
import 'package:provider/provider.dart';

import '../calendar_page/calendar_page.dart';
import '../home_page/home_page.dart';
import '../stats_page/stats_page.dart';

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
        create: (BuildContext context) => UserViewModel(),
        child: const HomePage()),
    const CalendarPage(),
    ChangeNotifierProvider(
      create: (_) => StatsListViewModel(),
      child: const StatsPage(),
    ),
  ];

  PageController controller = PageController();
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        onPageChanged: (page) {
          setState(() {
            selectedIndex = page;
          });
        },
        controller: controller,
        itemCount: _pages.length,
        itemBuilder: (context, index) {
          return _pages[index];
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                spreadRadius: -10,
                blurRadius: 60,
                color: Colors.black.withOpacity(.4),
                offset: Offset(0, 25),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 3),
            child: GNav(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              color: Colors.grey.shade800,
              tabActiveBorder: Border.all(),
              activeColor: Colors.black,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              gap: 10,
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.calendar_today,
                  text: 'Calendar',
                ),
                GButton(
                  icon: Icons.filter_alt_outlined,
                  text: 'Filter',
                )
              ],
              selectedIndex: selectedIndex,
              onTabChange: (index) {
                setState(() {
                  selectedIndex = index;
                });
                controller.jumpToPage(index);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class Dummy extends StatelessWidget {
  const Dummy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.greenAccent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () {
              // setState(() {
              //   index = 0;
              // });
            },
            icon: Icon(Icons.book_outlined),
          ),
          IconButton(
            onPressed: () {
              // setState(() {
              //   index = 1;
              // });
            },
            icon: Icon(Icons.calendar_today),
          ),
          IconButton(
            onPressed: () {
              // setState(() {
              //   index = 2;
              // });
            },
            icon: Icon(Icons.query_stats),
          ),
        ],
      ),
    );
  }
}
