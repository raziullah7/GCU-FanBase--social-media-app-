import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_final_app/components/my_button.dart';
import 'package:the_final_app/components/my_text_field.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({
    super.key,
    required this.onTap,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  // sign user in
  void signIn() async {
    // for loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );
    } on FirebaseAuthException catch (e) {
      displayMessage(e.code);
    }
  }

  // functoin to show the user the error message
  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(title: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // logo (please work)
                const Icon(Icons.lock, size: 100),

                // welcome back message
                const SizedBox(height: 50),
                Text(
                  "Welcome back, You've been missed!",
                  style: TextStyle(color: Colors.grey.shade800),
                ),

                // email text field
                const SizedBox(height: 25),
                MyTextField(
                  controller: emailTextController,
                  hintText: "Email",
                  obscureText: false,
                ),

                // password text field
                const SizedBox(height: 10),
                MyTextField(
                  controller: passwordTextController,
                  hintText: "Password",
                  obscureText: true,
                ),

                // sign in button
                const SizedBox(height: 25),
                MyButton(onTap: signIn, text: "Sign In"),

                // go to register page
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member?",
                      style: TextStyle(color: Colors.grey.shade800),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Register now",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
