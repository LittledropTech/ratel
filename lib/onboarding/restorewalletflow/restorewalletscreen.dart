
import 'package:bitsure/dashboard/pages/dashboard.dart';
import 'package:bitsure/onboarding/restorewalletflow/eneter_password.dart';
import 'package:bitsure/onboarding/restorewalletflow/mannual_restore.dart';
import 'package:bitsure/onboarding/restorewalletflow/poem_restore.dart';
import 'package:bitsure/onboarding/restorewalletflow/restore_new_code.dart';
import 'package:bitsure/provider/backup_logic_provider.dart';
import 'package:bitsure/utils/customutils.dart';
import 'package:bitsure/utils/textstyle.dart';
import 'package:bitsure/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Restorewalletscreen extends StatefulWidget {
  const Restorewalletscreen({super.key});

  @override
  State<Restorewalletscreen> createState() => _RestorewalletscreenState();
}

class _RestorewalletscreenState extends State<Restorewalletscreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Future<void> retrieveWalletSeedFromGoogleDrive(BuildContext context) async {
      // Get the tools we'll need from the context
      final backupProvider = Provider.of<BackupProvider>(
        context,
        listen: false,
      );
      final navigator = Navigator.of(context);
      final messenger = ScaffoldMessenger.of(context);


      final password = await navigator.push<String>(
        MaterialPageRoute(
          builder: (context) => const Restorewalletvalidatescreen(
            subpagetext: 'Let\'s get you in',
            pagetext: 'Enter Your Backup Password',
            text: 'verify',
          ),
        ),
      );

      if (password == null || password.isEmpty) {
        print("Password entry was cancelled by the user.");
        return; 
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        final List<String>? decryptedSeed = await backupProvider
            .findAndDecryptBackup(password);

        if (navigator.canPop()) {
          navigator.pop();
        }

        if (decryptedSeed != null) {
          print("Restore successful. Seed Phrase: $decryptedSeed");
          await navigator.pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const RestoreNewCode()),
            (Route<dynamic> route) => false,
          );
        } else {
          messenger.showSnackBar(
            const SnackBar(
              content: Text("Incorrect password or no matching backup found."),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (navigator.canPop()) {
          navigator.pop();
        }
        messenger.showSnackBar(
          SnackBar(
            content: Text("Restore Failed: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kbackupcolor,
        centerTitle: true,
        title: Text('Add Existing Wallet'),
      ),
      backgroundColor: kbackupcolor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 150),

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
                  () async {
                    await retrieveWalletSeedFromGoogleDrive(context);
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ManualRestoreScreen();
                        },
                      ),
                    );
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

                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return PoemRestoreScreen();
                        },
                      ),
                    );
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

              const SizedBox(height: 150),

              // Bottom Button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  customcontainer(
                    210,
                    210,
                    BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/vector4.png'),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    SizedBox(),
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
