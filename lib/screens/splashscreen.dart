import 'package:bitsure/utils/theme.dart';
import 'package:flutter/material.dart';

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
      body: Container(
        height: size.height,
        width: size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          kblackcolor,
          kbackgroundcolor,
        ],begin: Alignment.topLeft,end: Alignment.bottomRight),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('BitSure',style: TextStyle(color: kwhitecolor,fontSize: 24,letterSpacing: 1.5,fontStyle: FontStyle.italic)),
          SizedBox(
            height: 20,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: CircularProgressIndicator(
                
                color: kwhitecolor,
              ),
            ),
          )
        ],
      ),
    ),
    );
  }
}