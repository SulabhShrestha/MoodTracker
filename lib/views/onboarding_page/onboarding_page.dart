import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:mood_tracker/utils/constant.dart';
import 'package:mood_tracker/view_models/local_storage_view_model.dart';
import 'package:mood_tracker/views/continue_with_page/continue_with.dart';
import 'package:mood_tracker/views/root_page/root_page.dart';

class OnboardingPage extends StatelessWidget {
  OnboardingPage({super.key});

  List<Widget> pages = [
    Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: 1 / 1,
            child: SvgPicture.asset(
              'assets/person.svg',
            ),
          ),
          Constant().spaces.vertical24(),
          const Text(
            "Welcome to Mood Tracker",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text("Start your journey to emotional well-being."),
        ],
      ),
    ),
    Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AspectRatio(
              aspectRatio: 1 / 1,
              child: SvgPicture.asset('assets/spiderman.svg')),
          Constant().spaces.vertical24(),
          const Text(
            "Track Your Moods",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text("One-click mood tracking made easy."),
        ],
      ),
    ),
    Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AspectRatio(
              aspectRatio: 1 / 1, child: SvgPicture.asset('assets/phone.svg')),
          Constant().spaces.vertical24(),
          const Text(
            "Gain Insights",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text("Discover patterns, reflect, and grow."),
        ],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IntroductionScreen(
          showSkipButton: true,
          rawPages: pages,
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
