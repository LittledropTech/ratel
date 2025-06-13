import 'dart:math';
import 'package:bitsure/subscreens/createpinscreen.dart';
import 'package:bitsure/utils/customutils.dart' show custombuttons;
import 'package:flutter/material.dart';
import 'package:bitsure/utils/textstyle.dart';
import 'package:bitsure/utils/theme.dart';
import 'package:google_fonts/google_fonts.dart';

class Validateseedphrase extends StatefulWidget {
  final List<String> mnemonicWords;

  const Validateseedphrase({super.key, required this.mnemonicWords});

  @override
  State<Validateseedphrase> createState() => _ValidateseedphraseState();
}

class _ValidateseedphraseState extends State<Validateseedphrase> {
  final ScrollController _scrollController = ScrollController();
  final Map<int, TextEditingController> controllers = {};
  List<int> randomIndexes = [];

  @override
  void initState() {
    super.initState();
    _generateRandomIndexes();
  }

  void _generateRandomIndexes() {
    final rand = Random();
    final Set<int> indexSet = {};

    while (indexSet.length < 3) {
      indexSet.add(rand.nextInt(widget.mnemonicWords.length));
    }

    randomIndexes = indexSet.toList()..sort();

    for (int index in randomIndexes) {
      controllers[index] = TextEditingController();
    }
  }

  void _validate() {
    bool allCorrect = true;

    for (int index in randomIndexes) {
      final userInput = controllers[index]?.text.trim().toLowerCase() ?? '';
      final correctWord = widget.mnemonicWords[index].trim().toLowerCase();

      if (userInput != correctWord) {
        allCorrect = false;
         // Clear incorrect field
        controllers[index]?.clear();
      }
    }

    if (allCorrect) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Seed phrase verified successfully"),
          backgroundColor: klightbluecolor,
        ),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Createpinscreen();
      }));
    } else {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          padding: EdgeInsets.all(5),
          content: Center(child: Text("Incorrect seed phrase. Please try again.")),
          backgroundColor: kredcolor,
        ),
      );

      setState(() {}); // Rebuild to reflect cleared fields
    }
  }

  @override
  void dispose() {
    controllers.values.forEach((controller) => controller.dispose());
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kwhitecolor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kwhitecolor,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Let's test your knowledge",
            style: GoogleFonts.poppins(
              color: kblackcolor,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.only(bottom: 100),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 45),
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/meme6.png'),
                ),
                const SizedBox(height: 16),
                Text(
                  "Please fill in the missing words\n to confirm your backup.",
                  style: GoogleFonts.poppins(
                    color: kblackcolor,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 2.2,
                  children: List.generate(widget.mnemonicWords.length, (index) {
                    final isMissing = randomIndexes.contains(index);

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 48),
                        child: Center(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 24,
                                child: Text(
                                  '${index + 1}.',
                                  style: TextStyle(
                                    color: klightbluecolor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: isMissing
                                    ? TextField(
                                        controller: controllers[index],
                                        textAlign: TextAlign.center,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 4,
                                            horizontal: 4,
                                          ),
                                        ),
                                        style: const TextStyle(fontSize: 14),
                                      )
                                    : Text(
                                        widget.mnemonicWords[index],
                                        style: TextStyle(
                                          color: kblackcolor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: size.height / 7),
                custombuttons(
                  40,
                  size.width / 1.1,
                  BoxDecoration(
                    color: klightbluecolor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  _validate,
                  Center(child: Text('Got it', style: vheadingstextstyle)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
