import 'dart:convert';
import 'dart:ui';
import 'package:bitsure/provider/backup_logic_provider.dart';
import '../subscreens/createpinscreen.dart';
import '../subscreens/poemscreen.dart';
import '../subscreens/manuallybackupscreen.dart';
// Assuming this is the correct path.
import 'package:bitsure/utils/customutils.dart';
import 'package:bitsure/utils/textstyle.dart';
import 'package:bitsure/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Backupscreen extends StatefulWidget {
  final List<String> seedphrases;
   final bool showButton ;
  const Backupscreen({super.key, required this.seedphrases,this.showButton=true});

  @override
  State<Backupscreen> createState() => _BackupscreenState();
}

class _BackupscreenState extends State<Backupscreen> {
  final Map<String, bool> _backupstatus = {
    "goggle_drive": false,
    "manually": true,
    "meme_poem": false,
  };
    void initState() {
    super.initState();
    List<String> seeds = widget.seedphrases;
    print(seeds);
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kbackupcolor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              customcontainer(
                90,
                size.width,
                const BoxDecoration(),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back, color: kblackcolor),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'For Real Back this up',
                        style: GoogleFonts.poppins(
                          color: kblackcolor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 150),

              // Google Drive Button
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: custombuttons(
                  70,
                  size.width / 0.9,
                  BoxDecoration(
                    color: kwhitecolor,
                    boxShadow: [
                      BoxShadow(
                        color: kblackcolor,
                        spreadRadius: 0.5,
                        blurRadius: 0.5,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // handle fuctionality for backup with  Google Drive
                  () async {
                    final backupProvider = Provider.of<BackupProvider>(
                      context,
                      listen: false,
                    );

                    try {
                      // Show loading dialog
                      customdialog(
                        context,
                        ktransarentcolor,
                        Center(child: CircularProgressIndicator()),
                        false,
                      );

                      // STEP 1: Sign in with Google
                      final account = await backupProvider.signInWithGoogle();
                      if (account == null) {
                        if (!context.mounted) return;
                        Navigator.of(context).pop(); // Close loading
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Google sign-in cancelled."),
                          ),
                        );
                        return;
                      }

                      // STEP 2: Ask for password
                      if (!context.mounted) return;
                      final password = await backupProvider.promptPassword(
                        context,
                        ' Encrypt with  Password ',
                        'Set BackUp Password',
                        "You don't wanna be left in  the wild Besties",
                      );
                      if (password == null || password.isEmpty) {
                        if (!context.mounted) return;
                        Navigator.of(context).pop(); // Close loading
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Password is required for backup."),
                          ),
                        );
                        return;
                      }

                      // STEP 3: Encrypt seed
                      final encryptedMap = backupProvider.encryptSeed(
                        password,
                        widget.seedphrases,
                      );
                      final encryptedJson = jsonEncode(encryptedMap);

                      // STEP 4: Upload to Google Drive

                      await backupProvider.uploadToGoogleDrive(encryptedJson);

                      // Update UI
                      if (context.mounted) {
                        Navigator.of(context).pop(); // Close loading
                        setState(() {
                          _backupstatus['goggle_drive'] = true;
                        });

                        // STEP 5: Show success dialog
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (dialogContext) => Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 30,
                                horizontal: 20,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TweenAnimationBuilder<double>(
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    duration: const Duration(milliseconds: 600),
                                    builder: (context, value, child) {
                                      return Transform.scale(
                                        scale: value,
                                        child: const Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 80,
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    "Successfully saved to Google Drive\n ",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
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
                                          ), 
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
                                              'Do Not Lose Your Password',
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
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop();
                                    },
                                    child: const Text("Done"),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      if (!context.mounted) return;
                      Navigator.of(context).pop(); 
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Backup failed: ${e.toString()}"),
                        ),
                      );
                    }
                  },

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 8),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: Image.asset(
                                  'assets/Arrow1.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text('Google Drive', style: vbacktextstyle),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 75),
                        child: customStatusIndicator(
                          _backupstatus['goggle_drive']!,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 12.0),
                        child: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Manual Backup Button
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: custombuttons(
                  70,
                  size.width,
                  BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: kblackcolor,
                        spreadRadius: 0.5,
                        blurRadius: 0.5,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    color: kwhitecolor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  () {
                    if (!context.mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return Manuallybackupscreen(
                            mnemonicWords: widget.seedphrases,
                          );
                        },
                      ),
                    );
                    setState(() {
                      _backupstatus['manually'] = true;
                    });
                  },
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 8),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: Image.asset(
                                  'assets/Arrow0.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text('Manual', style: vbacktextstyle),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 110),
                        child: customStatusIndicator(
                          _backupstatus['manually']!,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 12.0),
                        child: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Meme Poem Backup
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: custombuttons(
                  70,
                  size.width,
                  BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: kblackcolor,
                        spreadRadius: 0.5,
                        blurRadius: 0.5,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    color: kwhitecolor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  () async {
                    final backupProvider = Provider.of<BackupProvider>(
                      context,
                      listen: false,
                    );
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    final navigator = Navigator.of(context);

                    try {
                      if (!context.mounted) return;
                      final password = await backupProvider.promptPassword(
                        context,
                        'Encrypt with Password',
                        'Set BackUp Password',
                        "You don't wanna be left in the wild Besties",
                      );

                      if (password == null || password.isEmpty) {
                        scaffoldMessenger.showSnackBar(
                          const SnackBar(
                            content: Text("Password is required."),
                          ),
                        );
                        return;
                      }

                     
                      final poem = backupProvider.generateRandomPoem();

                     
                      if (!context.mounted) return;
                      final bool? backupCompleted = await navigator.push(
                        MaterialPageRoute(
                          builder: (context) => PoemScreen(
                            poem: poem,
                            seedphrases: widget
                                .seedphrases, 
                            password: password, 
                          ),
                        ),
                      );

                    
                      if (backupCompleted == true) {
                       
                        setState(() {
                          _backupstatus['meme_poem'] = true;
                        });

                        if (!context.mounted) return;
                        scaffoldMessenger.showSnackBar(
                          SnackBar(
                            backgroundColor: klightbluecolor,
                            content: Text(
                              "Meme Poem backup successfully created!",
                            ),
                          ),
                        );
                      } else {
                       
                        scaffoldMessenger.showSnackBar(
                          const SnackBar(
                            content: Text("Backup process was cancelled."),
                          ),
                        );
                      }
                    } catch (e) {
                      if (!context.mounted) return;
                      scaffoldMessenger.showSnackBar(
                        SnackBar(content: Text("An error occurred: $e")),
                      );
                    }
                  },
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 8),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: Image.asset(
                                  'assets/Arrow2.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text('Meme poem', style: vbacktextstyle),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 75),
                        child: customStatusIndicator(
                          _backupstatus['meme_poem']!,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 12.0),
                        child: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 180),

            if(widget.showButton)
              custombuttons(
                40,
                size.width * 0.9,
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
                  borderRadius: BorderRadius.circular(30),
                ),
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Createpinscreen();
                      },
                    ),
                  );
                },
                Center(
                  child: Text(
                    "I've got it. I'm now responsible",
                    style: vbuttontextstyles,
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
