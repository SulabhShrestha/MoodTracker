import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mood_tracker/views/home_page/home_page.dart';
import 'package:mood_tracker/views/more_page/more_page.dart';

import '../calendar_page/calendar_page.dart';
import '../stats_page/stats_page.dart';
import 'utils/interaction_utils.dart';

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

  ConnectivityResult? connectivityResult;
  bool isDialogShown = false;

  @override
  void initState() {
    _checkInternetConnection();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        connectivityResult = result;
      });
    });

    _pages = <Widget>[
      const HomePage(),
      const CalendarPage(),
      const StatsPage(),
      const MorePage(),
    ];
    super.initState();
  }

  void _checkInternetConnection() async {
    connectivityResult = await Connectivity().checkConnectivity();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (connectivityResult == ConnectivityResult.none &&
        connectivityResult != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
            context: context,
            builder: (context) => noInternetConnection(context));
      });
    }
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
                context: context,
                builder: (context) => doYouWantToExit(context)) ??
            false;
      },
      child: Scaffold(
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
                  offset: const Offset(0, 25),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
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
        ),
      ),
    );
  }
}
