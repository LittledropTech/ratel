import 'dart:ui';

import '../../onboarding/screens/seedphrasescreen.dart';
import 'package:bitsure/utils/customutils.dart';
import 'package:bitsure/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/textstyle.dart';

class Policiesscreen extends StatefulWidget {
  List<String> mnemonics = [];
  Policiesscreen({super.key, required this.mnemonics});

  @override
  State<Policiesscreen> createState() => _PoliciesscreenState();
}

class _PoliciesscreenState extends State<Policiesscreen> {
  bool ackNonCustodian = false;
  bool ackSeedPhrase = false;
  bool ackResponsibility = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kwhitecolor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: customcontainer(
                    size.height * 0.8,
                    size.width / 1.1,
                    BoxDecoration(
                      color: ktransarentcolor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 100),
                          CircleAvatar(
                            radius: 60,
                            child: Center(
                              child: Icon(
                                Icons.key,
                                size: 35,
                                color: klightbluecolor,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "You're the Captain Now",
                            style: GoogleFonts.quicksand(
                              color: kblackcolor,
                              fontSize: 25,
                            ),
                          ),
                          SizedBox(height: 30),
                          customcontainer(
                            size.height * 0.4,
                            size.width / 1.2,
                            BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: kblackcolor,
                                  spreadRadius: 0.5,
                                  blurRadius: 0.5,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(20),
                              color: klightbluecolor,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                  ),
                                  child: Center(
                                    child: Column(
                                    
                                      children: [
                                        Text(
                                          'With great power comes great responsibility.',
                                          style: GoogleFonts.poppins(
                                            color: kwhitecolor,
                                            fontSize: 17,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'You and only you will have access to your wallet keys,',
                                          style: GoogleFonts.poppins(
                                            color: kwhitecolor,
                                            fontSize: 17,
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          'If you lose your keys, not even your mum can save you',
                                          style: GoogleFonts.poppins(
                                            color: kwhitecolor,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 40,
                                    left: 6,
                                    right: 6,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(2),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 10,
                                        sigmaY: 10,
                                      ),
                                      child: customcontainer(
                                        40,
                                        size.width / 1.2,
                                        BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            2,
                                          ),
                                          color: kwhitecolor.withOpacity(
                                            0.5,
                                          ), // translucent color
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                15.0,
                                              ),
                                              child: Icon(
                                                Icons.error_outline,
                                                color: kredcolor,
                                              ), // optional style
                                            ),
                                            Text(
                                              'No support Email,No forgot Key \nButton,You must save this properly',
                                              style: GoogleFonts.quicksand(
                                                color: kredcolor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            buildClauseCheckbox(
              title: "I understand I'm responsible for my keys and funds",

              value: ackNonCustodian,
              onChanged: (val) {
                setState(() {
                  ackNonCustodian = val ?? false;
                });
              },
            ),
            SizedBox(height: 15),
            if (ackNonCustodian)
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: custombuttons(
                  40,
                  size.width / 1.2,
                  BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: kblackcolor,
                        spreadRadius: 0.5,
                        blurRadius: 0.5,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    color: klightbluecolor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return Seedphrasescreen(
                            mnemonicWords: widget.mnemonics,
                          );
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
              ),
          ],
        ),
      ),
    );
  }

  Widget buildClauseCheckbox({
    required String title,
    required bool value,
    required void Function(bool?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: klightbluecolor,
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.poppins(
                  color: kbackgroundcolor,
                  fontSize: 14,
                ),
                children: [
                  TextSpan(
                    text: '$title\n',
                    style: TextStyle(color: kbackgroundcolor, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
