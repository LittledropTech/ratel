import 'package:bitsure/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  Widget build(BuildContext context) {
       final size = MediaQuery.of(context).size;
    return Scaffold(
      body:  SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 700,
              width: 400,
              child: Center(child: Lottie.asset('assets/play.json',repeat: true,reverse: true,height: size.height)))
          ],
        ),
      )
    );
  }
}