import 'package:bitsure/dashboard/pages/dashboard.dart';
import 'package:bitsure/gen/assets.gen.dart';
import 'package:bitsure/provider/backup_logic_provider.dart';
import 'package:bitsure/utils/customutils.dart';
import 'package:bitsure/utils/textstyle.dart';
import 'package:bitsure/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllBagsscreen extends StatefulWidget {
  const AllBagsscreen({super.key});

  @override
  State<AllBagsscreen> createState() => _AllBagsscreenState();
}

class _AllBagsscreenState extends State<AllBagsscreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Future<void> retrieveWalletSeedFromGoogleDrive(BuildContext context) async {
    //   // Get the tools we'll need from the context
    //   final backupProvider = Provider.of<BackupProvider>(
    //     context,
    //     listen: false,
    //   );
    //   final navigator = Navigator.of(context);
    //   final messenger = ScaffoldMessenger.of(context);

    //   // --- STEP 1: Get the password from the user FIRST ---
    //   // The process cannot start until we have the password.
    //   // final password = await navigator.push<String>(
    //   //   MaterialPageRoute(
    //   //     builder: (context) => const AllBagsvalidatescreen(
    //   //       subpagetext: 'Let\'s get you in',
    //   //       pagetext: 'Enter Your Backup Password',
    //   //       text: 'verify',
    //   //     ),
    //   //   ),
    //   // );

    //   // --- STEP 2: Check if the user cancelled the password screen ---
    //   if (password == null || password.isEmpty) {
    //     print("Password entry was cancelled by the user.");
    //     return; // Exit the function if no password was provided.
    //   }

    //   // --- STEP 3: Show a loading indicator ---
    //   // Now that we have the password, we can start the search.
    //   showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (context) => const Center(child: CircularProgressIndicator()),
    //   );

    //   try {
    //     // --- STEP 4: Call the single provider function that does all the work ---
    //     // It will find all backups and try the provided password on each one.
    //     // The function returns the decrypted List<String> on success, or null on failure.
    //     final List<String>? decryptedSeed = await backupProvider
    //         .findAndDecryptBackup(password);

    //     // The search is complete, so we can remove the loading indicator.
    //     if (navigator.canPop()) {
    //       navigator.pop();
    //     }

    //     // --- STEP 5: Check the result and navigate accordingly ---
    //     if (decryptedSeed != null) {
    //       // SUCCESS! A backup was unlocked with the password.
    //       print("Restore successful. Seed Phrase: $decryptedSeed");
    //       await navigator.pushAndRemoveUntil(
    //         MaterialPageRoute(builder: (context) => const RestoreNewCode()),
    //         (Route<dynamic> route) => false,
    //       );
    //     } else {
    //       // FAILURE: The password was wrong for all backups found.
    //       messenger.showSnackBar(
    //         const SnackBar(
    //           content: Text("Incorrect password or no matching backup found."),
    //           backgroundColor: Colors.red,
    //         ),
    //       );
    //     }
    //   } catch (e) {
    //     // This handles other potential errors (e.g., no internet, Google Drive API issues).
    //     if (navigator.canPop()) {
    //       navigator.pop();
    //     }
    //     messenger.showSnackBar(
    //       SnackBar(
    //         content: Text("Restore Failed: ${e.toString()}"),
    //         backgroundColor: Colors.red,
    //       ),
    //     );
    //   }
    // }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kbackupcolor,
        centerTitle: true,
        title: Text('All your bags'),
      ),
      backgroundColor: kbackupcolor,
      
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
ListView(
  shrinkWrap: true,
  children: [

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: custombuttons(
                  70,
                  size.width / 0.9,
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
                  // handle fuctionality for retrieve  with  Google Drive
                  () async {
                    // await retrieveWalletSeedFromGoogleDrive(context);
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
                                  Assets.meme1.path,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text('Main Wallet 1', style: vbacktextstyle),
                        ],
                      ),

                      const Padding(
                        padding: EdgeInsets.only(right: 12.0),
                        child: Icon(
                          Icons.more_vert,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
  ]),

  
            ],
          ),
        ),
      ),
    );
  }
}
