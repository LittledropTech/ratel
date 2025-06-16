
import 'validateseedphrase.dart';
import 'backupscreen.dart';
import 'package:bitsure/utils/customutils.dart';
import 'package:bitsure/utils/textstyle.dart';
import 'package:bitsure/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:google_fonts/google_fonts.dart';

class Seedphrasescreen extends StatefulWidget {
  final List<String> mnemonicWords;
  Seedphrasescreen({super.key, required this.mnemonicWords});

  @override
  State<Seedphrasescreen> createState() => _SeedphrasescreenState();
}

class _SeedphrasescreenState extends State<Seedphrasescreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          ' Generate Seed Phrase',
          style: GoogleFonts.poppins(
            color: kblackcolor,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: kwhitecolor,
      ),
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [kwhitecolor, kwhitecolor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 25),
              Padding(
                padding: EdgeInsets.all(15.0),
                child: CircleAvatar(
                  radius: 65,
                  backgroundImage: AssetImage('assets/meme4.png'),
                ),
              ),
              Text(
                "Your secret word\n P.S don't pass it ",
                style: GoogleFonts.quicksand(fontSize: 20),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Icon(Icons.error_outline, color: kgoldencolor),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Lose this? GG We can't help you. Not even \nyour mom",
                      style: TextStyle(color: Color.fromARGB(255, 221, 173, 2)),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(widget.mnemonicWords.length, (index) {
                    return Container(
                      width: 102, // Fixed width for all chips
                      height: 45, // Fixed height for all chips
                      child: Chip(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        labelPadding: EdgeInsets.zero, // Remove default padding
                        backgroundColor: Colors.grey.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        label: Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('${index + 1}. ',style: TextStyle(color: klightbluecolor),),
                                Text(
                                  "${widget.mnemonicWords[index]}",
                                  style: const TextStyle(
                                    fontSize:
                                        14, // Slightly smaller to fit better
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2, // Allow up to 2 lines if needed
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    final fullMnemonic = widget.mnemonicWords.join(' ');
                    Clipboard.setData(ClipboardData(text: fullMnemonic));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Seed phrase copied to clipboard'),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.copy, color: kblackcolor, size: 15),
                      ),
                      Text(
                        'Copy Seed Phrase',
                        style: GoogleFonts.poppins(
                          color: kblackcolor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 13),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: custombuttons(
                      40,
                      150,
                      BoxDecoration(
                        color: klightbluecolor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Validateseedphrase(
                                mnemonicWords: widget.mnemonicWords,
                              );
                            },
                          ),
                        );
                      },
                      Center(
                        child: Text('continue', style: vsubheadingstextstyle),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: custombuttons(
                      40,
                      150,
                      BoxDecoration(
                        color: kbackgroundcolor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Backupscreen(
                                seedphrases: widget.mnemonicWords,
                              );
                            },
                          ),
                        );
                      },
                      Center(
                        child: Text('Back Up', style: vsubheadingstextstyle),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
