import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/auth_screens/signin_screen.dart';
import '../screens/home_screen.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/text_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Add a delay to navigate to the home screen after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      // Check if the user is already authenticated
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user != null) {
          // User is logged in, navigate to the home screen
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const HomeScreen()), // Replace HomeScreen with your home screen widget
          );
        } else {
          // User is not logged in, navigate to the sign-in screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignInScreen()),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image.asset('assets/images/app_icon.png', width: 150, height: 150),
            // SizedBox(height: 80),
            TextWidget(
              text: appName,
              fontSize: 20,
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }
}
