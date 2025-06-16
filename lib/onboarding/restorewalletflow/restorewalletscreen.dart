
import 'package:bitsure/dashboard/pages/dashboard.dart';
import 'package:bitsure/onboarding/restorewalletflow/eneter_password.dart';
import 'package:bitsure/onboarding/restorewalletflow/mannual_restore.dart';
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
  final backupProvider = Provider.of<BackupProvider>(context, listen: false);
  final messenger = ScaffoldMessenger.of(context);
  final navigator = Navigator.of(context);
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );
  try {
    final encryptedPhrase = await backupProvider.downloadEncryptedBackup();
    final password = await navigator.push<String>(
      MaterialPageRoute(
        builder: (context) => Restorewalletvalidatescreen(subpagetext: 'Let gets you In ', pagetext: 'Enter Your BackUp Password' ,text: 'verify')
      ),
    );
    if (password == null || password.isEmpty) {
      navigator.pop();
      return;
    }
    final List<String> decryptedSeed = backupProvider.decryptSeed(
      encryptedPhrase!, // We know this is not null if the download succeeded
      password,
    );
    print("Decryption successful. Seed Phrase: $decryptedSeed");
    await navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => RestoreNewCode()),
      (Route<dynamic> route) => false,
    );

  } catch (e) {
    navigator.pop();
    messenger.showSnackBar(
      SnackBar(
        content: Text("Error: ${e.toString()}"),
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
                    color: kwhitecolor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // handle fuctionality for retrieve  with  Google Drive
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
                    color: kwhitecolor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  () {
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return ManualRestoreScreen();
                    }));
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
                    color: kwhitecolor,
                    borderRadius: BorderRadius.circular(10),
                  ),

                  //the fuction that handles the backup with Meme poem
                  () {},
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
