import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_new_sustain_app/screens/Homepages/Select_Screen.dart';
import 'package:my_new_sustain_app/screens/Starting%20Screens/OnboardingScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateUser(); // Check user login status
  }

  void navigateUser() async {
    await Future.delayed(const Duration(seconds: 3)); // Splash screen delay

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // If user is signed in ➔ go to HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SelectScreen()),
      );
    } else {
      // If user is NOT signed in ➔ go to Onboarding Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/sustainlogo.png', // Ensure this path is correct
              width: 150, // Increase width
              height: 150, // Increase height
            ),
            const SizedBox(height: 20),
            const Text(
              'SustainTip',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
