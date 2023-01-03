import 'package:flutter/material.dart';
import 'package:mood_tracker/views/core/heading_textfield.dart';

import '../core/button.dart';
import '../sign_up_page/sign_up.dart';

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
                  backgroundColor: Colors.blueGrey,
                  child: const Text("Sign in"),
                ),

                // Navigating to sign up screen
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const SignUpPage()));
                      },
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
