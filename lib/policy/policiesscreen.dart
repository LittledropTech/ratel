
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
    bool allChecked = ackNonCustodian && ackSeedPhrase && ackResponsibility;

    return Scaffold(
      backgroundColor: kwhitecolor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(right: 140,top: 15),
              child: Text('Terms and conditions ', style: GoogleFonts.poppins(color: kbackgroundcolor,fontSize: 17,fontWeight: FontWeight.bold))
            ),
            SizedBox(height: 12),
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
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: 
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "⚠️ Welcome to BitSure\na Non-custodian Bitcoin wallet.By using this application, you agree to the following Terms and Conditions. Please read them carefully before proceeding.",
                                    style: GoogleFonts.poppins(
                                      color: kgoldencolor,
                                    ),
                                  ),
                               
                            ),
                          ),
                          SizedBox(height: 8),
                  
                          // Clause 1
                          buildClauseCheckbox(
                            title: 'Non-Custodian Acknowledgement:',
                            description:
                                'You understand and acknowledge that this wallet is non-custodial, meaning: You, and only you, control the private keys. We do not have access to your seed phrase, wallet, or funds. You are fully responsible for securing your wallet and recovery phrase.',
                            value: ackNonCustodian,
                            onChanged: (val) {
                              setState(() {
                                ackNonCustodian = val ?? false;
                              });
                            },
                          ),
                  
                          SizedBox(height: 5.0),
                  
                          // Clause 2
                          buildClauseCheckbox(
                            title: ' Seed Phrase & Security:',
                            description:
                                'You must securely back up your 12 seed phrase. Losing access to your seed phrase means losing access to your wallet and funds permanently. We cannot help recover lost seed phrases or funds.',
                            value: ackSeedPhrase,
                            onChanged: (val) {
                              setState(() {
                                ackSeedPhrase = val ?? false;
                              });
                            },
                          ),
                  
                          SizedBox(height: 8),
                  
                          //  Clause 3
                          buildClauseCheckbox(
                            title: 'Your Responsibility:',
                            description:
                                'You are responsible for maintaining the security of your wallet and private keys. Ensure you take serious precautions to safeguard your recovery phrase and authentication credentials. Failure to protect your access information may result in irreversible loss of funds and data.',
                            value: ackResponsibility,
                            onChanged: (val) {
                              setState(() {
                                ackResponsibility = val ?? false;
                              });
                            },
                          ),
                  
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            if (allChecked)
              custombuttons(
                40,
                size.width / 1.4,
                BoxDecoration(
                  color: klightbluecolor,
                  borderRadius: BorderRadius.circular(20),
                ),
                () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Seedphrasescreen(mnemonicWords: widget.mnemonics);
                  }));
                },
                Center(child: Text('Continue', style: vbuttontextstyles)),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildClauseCheckbox({
    required String title,
    required String description,
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
                    style: TextStyle(
                      color: klightbluecolor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
