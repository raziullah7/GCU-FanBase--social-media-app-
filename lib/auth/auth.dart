import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_final_app/auth/login_or_register.dart';
import 'package:the_final_app/pages/home_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        // the stream is to detect any changes to the auth state
        // it tells if the user is logged in or not
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // if user is logged in
          if (snapshot.hasData) {
            return const HomePage();
          }
          // else if user is not logged in
          else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
