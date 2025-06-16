import 'package:bitsure/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:google_fonts/google_fonts.dart';

class Manuallybackupscreen extends StatefulWidget {
  final  List<String> mnemonicWords;
  const Manuallybackupscreen({super.key, required this.mnemonicWords});

  @override
  State<Manuallybackupscreen> createState() => _ManuallybackupscreenState();
}

class _ManuallybackupscreenState extends State<Manuallybackupscreen> {
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
            fontWeight: FontWeight.bold,
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
                  radius: 70,
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
                    return SizedBox(
                      width: 106, // Fixed width for all chips
                      height: 45, // Fixed height for all chips
                      child: Chip(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        labelPadding: EdgeInsets.zero, // Remove default padding
                        backgroundColor: Colors.grey.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        label: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('${index + 1}. ',style: TextStyle(color: klightbluecolor),),
                                Text(
                                  widget.mnemonicWords[index],
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
              SizedBox(height: 40,),
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
                        icon: Icon(Icons.copy, color: kblackcolor, size: 20),
                      ),
                      Text(
                        'Copy Seed Phrase',
                        style: GoogleFonts.poppins(
                          color: kblackcolor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 2),

           
            ],
          ),
        ),
      ),
    );
  }
}