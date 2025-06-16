import 'package:bitsure/animate/boundingimagescreen.dart';
import 'package:bitsure/network/createwallet.dart';
import 'package:bitsure/utils/textstyle.dart';
import 'optionscreen.dart' show Optionscreen;
import 'package:bitsure/utils/customutils.dart';
import 'package:bitsure/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;

class Introscreen extends StatefulWidget {
  const Introscreen({super.key});

  @override
  State<Introscreen> createState() => _IntroscreenState();
}

class _IntroscreenState extends State<Introscreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.height > 750;
    final double width = isLandscape
        ? size.width * 1.5
        : isLandscape
        ? size.width * 0.5
        : size.width;

    final double height = isLandscape
        ? size.height * 1
        : isLandscape
        ? size.height * 1.5
        : size.height;
    return Scaffold(
      backgroundColor: kwhitecolor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // This top container with the title and animation is unchanged.
              SingleChildScrollView(
                child: Container(
                  color: kwhitecolor,
                  width: width,
                  height: height,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 80,
                        child: Text(
                          'RATEL',
                          style: GoogleFonts.quicksand(
                            shadows: [
                              BoxShadow(
                                color: kbackupcolor,
                                spreadRadius: 0.5,
                                blurRadius: 3,
                                offset: const Offset(0, 5),
                              ),
                            ],
                            textStyle: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: klightbluecolor,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 50,
                        right: size.width / 1.6,
                        child: customcontainer(
                          210,
                          size.width / 1.8,
                          BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/vector5.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(),
                        ),
                      ),
                      Positioned.fill(
                        child: Opacity(
                          opacity: 0.8,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: BouncingImagesScreen(),
                          ),
                        ),
                      ),
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
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.05,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              ' The first Bitcoin\n wallet with ADHD\n and vibes',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.quicksand(
                                textStyle: TextStyle(
                                  fontSize: isLandscape ? 30 : 24,

                                  color: kblackcolor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        top: 430,
                        left: size.width / 1.6,
                        child: customcontainer(
                          210,
                          size.width / 2.1,
                          BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/vector6.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(),
                        ),
                      ),
                      Positioned(
                        top: size.height * 0.8,
                        child: TweenAnimationBuilder<Offset>(
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
                              top: 60,

                              bottom: size.height * 0.05,
                            ),

                            // We use a Stack to layer the button on top of the image.
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // The image is positioned at the bottom-left of the Stack.
                                // The button is centered on top of the image.
                                custombuttons(
                                  42,
                                  size.width * 0.8,
                                  BoxDecoration(
                                    color: klightbluecolor,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: kblackcolor,
                                        spreadRadius: 0.5,
                                        blurRadius: 3,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
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

                                        fontSize: isLandscape ? 18 : 16,

                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
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
