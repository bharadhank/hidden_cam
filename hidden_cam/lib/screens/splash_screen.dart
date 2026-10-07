import 'package:flutter/material.dart';
import '../widgets/avatar_guide.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AvatarGuide(
              state: AvatarState.greeting,
              speechText: 'Welcome to SafeLens.\nYour privacy. Your safety.',
            ),
            const SizedBox(height: 40),
            CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
