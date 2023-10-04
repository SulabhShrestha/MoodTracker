import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:mood_tracker/utils/constant.dart';
import 'package:mood_tracker/view_models/local_storage_view_model.dart';
import 'package:mood_tracker/views/continue_with_page/continue_with.dart';
import 'package:mood_tracker/views/root_page/root_page.dart';

class OnboardingPage extends StatelessWidget {
  OnboardingPage({super.key});

  List<PageViewModel> pages = [
    PageViewModel(
      title: "Welcome to Mood Tracker",
      body: "Start your journey to emotional well-being.",
      image: Icon(Icons.waving_hand, size: 50.0),
    ),
    PageViewModel(
      title: "Track Your Moods",
      body: "One-click mood tracking made easy.",
      image: Icon(Icons.waving_hand, size: 50.0),
    ),
    PageViewModel(
      title: "Gain Insights",
      body: "Discover patterns, reflect, and grow.",
      image: Icon(Icons.waving_hand, size: 50.0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IntroductionScreen(
          pages: pages,
          showSkipButton: true,
          skip: const Text("Skip"),
          next: const Text("Next"),
          done:
              const Text("Done", style: TextStyle(fontWeight: FontWeight.w700)),
          onDone: () {
            _onIntroEnd(context);
          },
          onSkip: () {
            _onIntroEnd(context);
          },
          nextStyle: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Constant().colors.green),
          ),
          doneStyle: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Constant().colors.green),
          ),
          skipStyle: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Constant().colors.darkRed),
          ),
          dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            activeColor: Constant().colors.secondary,
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
          ),
        ),
      ),
    );
  }

  void _onIntroEnd(context) {
    LocalStorageViewModel().setIsAppLaunchedFirstTime();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const ContinueWithPage()),
    );
  }
}
