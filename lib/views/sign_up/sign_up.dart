import 'package:flutter/material.dart';
import 'package:mood_tracker/views/sign_in/sign_in.dart';

import '../core/button.dart';
import '../core/heading_textfield.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

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

                const HeadingTextField(
                  heading: "Confirm password",
                  obscureText: true,
                ),

                Button(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SignInPage()));
                  },
                  backgroundColor: Colors.blueGrey,
                  child: const Text("Sign Up"),
                ),

                // Navigating to sign up screen
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Have an account?"),
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
