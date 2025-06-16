import 'package:bitsure/onboarding/screens/introscreen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:bitsure/utils/theme.dart'; 

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

// We add 'SingleTickerProviderStateMixin' to allow our state to be a Ticker for the animation
class _SplashscreenState extends State<Splashscreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Initialize the AnimationController
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500), // How long the animation takes
      vsync: this,
    );

    // 2. Create the Animation
    // We use a CurvedAnimation to make the zoom effect feel more natural (ease in and out)
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // 3. Start the animation
    _controller.forward();

    // 4. Navigate to the next screen after a delay
    // The delay should be slightly longer than the animation duration
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Introscreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    // 5. Clean up the controller when the widget is removed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kwhitecolor, // Assuming kwhitecolor is defined in your theme
      body: Center(
        // 6. Use the ScaleTransition widget to apply the animation
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: SizedBox(
            width: size.width * 0.6, // Use a percentage for better responsiveness
            height: size.width * 0.6,
            child: Image.asset(
              'assets/logo.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
