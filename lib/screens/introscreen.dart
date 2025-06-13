
import 'package:bitsure/animate/boundingimagescreen.dart';
import 'package:bitsure/screens/optionscreen.dart' show Optionscreen;
import 'package:bitsure/utils/customutils.dart';
import 'package:bitsure/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:lottie/lottie.dart';

class Introscreen extends StatefulWidget {
  const Introscreen({super.key});

  @override
  State<Introscreen> createState() => _IntroscreenState();
}

class _IntroscreenState extends State<Introscreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.height > 700;

    return Scaffold(
      backgroundColor: kwhitecolor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: isLargeScreen ? size.height * 0.7 : size.height * 0.6,
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(50),
                    bottomLeft: Radius.circular(50),
                  ),
                  gradient: LinearGradient(
                    colors: [kbackgroundcolor,kbackgroundcolor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Lottie animation
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.8,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: BouncingImagesScreen()
                        ),
                      ),
                    ),

                    // Animated text on top of Lottie
                    TweenAnimationBuilder<Offset>(
                      tween: Tween<Offset>(
                        begin: const Offset(0, -2.5),
                        end: const Offset(0, 0),
                      ),
                      duration: const Duration(seconds: 4),
                      curve: Curves.easeOut,
                      builder: (context, offset, child) {
                        return Transform.translate(
                          offset: Offset(0, offset.dy * 100),
                          child: child,
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                        child: Text(
                          ' The First Bitcoin\n Wallet\nwith ADHD and Vibes',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              fontSize: isLargeScreen ? 30 : 24,
                              fontWeight: FontWeight.bold,
                              color: kwhitecolor,
                            ),
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.5),
                                offset: const Offset(2, 2),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 40,),
              TweenAnimationBuilder<Offset>(
                tween: Tween<Offset>(
                  begin: const Offset(-1.5, 0),
                  end: const Offset(0, 0),
                ),
                duration: const Duration(seconds: 4),
                curve: Curves.easeOut,
                builder: (context, offset, child) {
                  return Transform.translate(
                    offset: Offset(offset.dx * size.width, 0),
                    child: child,
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(
                    top: size.height * 0.04,
                    bottom: size.height * 0.05,
                  ),
                  
                  child: custombuttons(
                    40,
                    size.width * 0.75,
                    BoxDecoration(
                      color: klightbluecolor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const Optionscreen();
                          },
                        ),
                      );
                    },
                  
                    Center(
                      child: Text(
                        'Get started',
                        style: TextStyle(
                          color: kwhitecolor,
                          fontSize: isLargeScreen ? 18 : 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
