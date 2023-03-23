import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mood_tracker/bloc/bottom_navbar_bloc.dart';
import 'package:mood_tracker/models/first_day_of_week_model.dart';
import 'package:mood_tracker/view_models/stats_list_view_model.dart';
import 'package:mood_tracker/view_models/user_view_model.dart';
import 'package:mood_tracker/views/home_page/home_page.dart';
import 'package:mood_tracker/views/more_page/more_page.dart';
import 'package:provider/provider.dart';

import '../calendar_page/calendar_page.dart';
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
  List<Widget> _pages = [];

  PageController controller = PageController();
  int selectedIndex = 0;

  BottomNavBarBloc barBloc = BottomNavBarBloc();

  @override
  void initState() {
    _pages = <Widget>[
      ChangeNotifierProvider(
          create: (BuildContext context) => UserViewModel(),
          child: const HomePage()),
      const CalendarPage(),
      ChangeNotifierProvider(
        create: (_) => StatsListViewModel(),
        child: const StatsPage(),
      ),
      const MorePage(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log("Current page: $selectedIndex");
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Confirm'),
                content:
                    const Text('Are you sure you want to close this screen?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Yes'),
                  ),
                ],
              ),
            ) ??
            false;
      },
      child: Scaffold(
          body: MultiProvider(
            providers: [
              Provider<BottomNavBarBloc>(create: (context) => barBloc),
              Provider<FirstDayOfWeekModel>(
                  create: (context) => FirstDayOfWeekModel()),
            ],
            builder: (_, child) {
              return PageView.builder(
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
              );
            },
          ),
          bottomNavigationBar: StreamBuilder<bool>(
              initialData: true,
              stream: barBloc.counterStream,
              builder: (context, snapshot) {
                // if false
                if (snapshot.hasData && !snapshot.data!) {
                  return const SizedBox();
                }
                return SafeArea(
                  child: Container(
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: -10,
                          blurRadius: 60,
                          color: Colors.black.withOpacity(.4),
                          offset: const Offset(0, 25),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 3.0, vertical: 3),
                      child: GNav(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        color: Colors.grey.shade800,
                        tabActiveBorder: Border.all(),
                        activeColor: Colors.black,
                        iconSize: 24,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 12),
                        gap: 10,
                        tabs: const [
                          GButton(
                            icon: Icons.home,
                            text: 'Home',
                          ),
                          GButton(
                            icon: Icons.calendar_month,
                            text: 'Calendar',
                          ),
                          GButton(
                            icon: Icons.filter_alt_outlined,
                            text: 'Filter',
                          ),
                          GButton(
                            icon: Icons.more_horiz,
                            text: 'More',
                          ),
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
                );
              })),
    );
  }
}
