import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../onboarding/screens/seedphrasescreen.dart';
import 'package:bitsure/utils/customutils.dart';
import 'package:bitsure/utils/theme.dart';
import 'package:bitsure/utils/textstyle.dart';

class Policiesscreen extends StatefulWidget {
  final List<String> mnemonics;
  const Policiesscreen({super.key, required this.mnemonics});

  @override
  State<Policiesscreen> createState() => _PoliciesscreenState();
}

class _PoliciesscreenState extends State<Policiesscreen> {
  bool ackNonCustodian = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kwhitecolor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),

              // --- Top Section ---
              customcontainer(
                150,
                200,
                const BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/meme10.png')),
                  shape: BoxShape.circle,
                ),
                const SizedBox(),
              ),
              const SizedBox(height: 8),
              Text(
                "You're the Captain Now",
                style: GoogleFonts.quicksand(
                  color: kblackcolor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),

              // --- Light Blue Information Container ---
              customcontainer(
                290, // Let the height be determined by the content
                size.width,
                BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: kblackcolor.withOpacity(0.4),
                      spreadRadius: 0.5,
                      blurRadius: 3,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                  color: klightbluecolor,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  child: Column(
                    children: [
                      Text(
                        "With great power comes great responsibility.\n You and only you will have access to your wallet keys. \nIf you lose your keys, not even your mum can save you.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: kwhitecolor,
                          fontSize: 17,
                          height: 1.4, // Improves line spacing
                        ),
                      ),
                      const SizedBox(height: 30),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: kwhitecolor.withOpacity(0.2),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error_outline, color: kredcolor),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'No support email, No forgot key button. You must save this properly.',
                                    style: GoogleFonts.quicksand(
                                      color: kredcolor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
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

              // --- THIS IS THE FIX: Checkbox and Button are now directly below ---
              const SizedBox(height: 30),
              buildClauseCheckbox(
                title: "I understand I'm responsible for my keys and funds",
                value: ackNonCustodian,
                onChanged: (val) {
                  setState(() {
                    ackNonCustodian = val ?? false;
                  });
                },
              ),
              const SizedBox(height: 50),
              // The button now only appears after the box is checked
              if (ackNonCustodian)
                custombuttons(
                  45,
                  size.width * 0.9,
                  BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: kblackcolor.withOpacity(0.4),
                        spreadRadius: 0.5,
                        blurRadius: 3,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    color: klightbluecolor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return Seedphrasescreen(mnemonicWords: widget.mnemonics);
                        },
                      ),
                    );
                  },
                  Center(
                    child: Text(
                      "I'm Ready, Let's Go",
                      style: vbuttontextstyles,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Checkbox widget remains the same
  Widget buildClauseCheckbox({
    required String title,
    required bool value,
    required void Function(bool?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: () => onChanged(!value),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: klightbluecolor,
            ),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(color: kbackgroundcolor, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
