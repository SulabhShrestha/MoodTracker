import 'package:flutter/material.dart';
import 'package:mood_tracker/views/sign_in/widgets/heading_textfield.dart';

import 'widgets/button.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Placeholder(),
                const HeadingTextField(
                  heading: "Email",
                  obscureText: false,
                ),
                const HeadingTextField(
                  heading: "Password",
                  obscureText: true,
                ),

                Button(
                  onTap: () {},
                  child: const Text("Log in"),
                ),

                // Navigating to sign up screen
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have account?"),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        "Sign up",
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                ),
                Text("OR"),

                Button(child: Text("Google"), onTap: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
