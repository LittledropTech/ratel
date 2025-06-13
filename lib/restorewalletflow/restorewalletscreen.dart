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
    final backupProvider = Provider.of<BackupProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;
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
                    await backupProvider.promptPassword(
                      context,
                      'i got it ',
                      'Enter Backup password ',
                      "Sorry bestie it's all for your good",
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
