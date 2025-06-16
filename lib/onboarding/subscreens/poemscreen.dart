import 'package:bitsure/provider/backup_logic_provider.dart';
import 'package:bitsure/utils/customutils.dart';
import 'package:bitsure/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PoemScreen extends StatelessWidget {
  final String poem;
    final String password; 
  final List<String> seedphrases;

  const PoemScreen({super.key, required this.poem, required this.seedphrases, required this.password});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Generated Poem")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Text(
                '⚠️ NOTE: DO NOT SHARE THIS POEM!.',
                style: TextStyle(color: kgoldencolor),
              ),
              const SizedBox(height: 20),
              Stack(
                children: [
                  Positioned(
                    child: customcontainer(
                      size.height / 1.9,
                      size.width / 1.1,
                      BoxDecoration(
                        color: kgoldencolor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      SizedBox(),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 12.5,
                    child: customcontainer(
                      size.height / 2,
                      size.width / 1.2,
                      BoxDecoration(
                        color: kwhitecolor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '"$poem"',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/meme7.png'),
              ),
              const SizedBox(height: 15),
              custombuttons(
                40,
                size.width / 1.2,
                BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 2,
                      spreadRadius: 1,
                      blurStyle: BlurStyle.outer,
                      color: kbackgroundcolor,
                    ),
                  ],
                  color: klightbluecolor,
                  borderRadius: BorderRadius.circular(20),
                ),
                () async {
                  try {
                    final backupProvider = Provider.of<BackupProvider>(
                      context,
                      listen: false,
                    );
                      final String seedPhraseString = seedphrases.join(' ');
                    final filePath = await backupProvider.generateAndSavePoemBackup(poem: poem, password: password, seedPhrase: seedPhraseString);
                       

                    if (filePath != null) {
                      customSnackBar(
                        '" Poem saved to: $filePath"',
                        klightbluecolor,
                        context,
                      );
                      Navigator.pop(context, true); // Success
                    } else {
                      customSnackBar(
                        'Failed to save poem',
                        klightbluecolor,
                        context,
                      );
                    }
                  } catch (e) {
                    customSnackBar(
                      'An error occured while saving poem',
                      klightbluecolor,
                      context,
                    );
                  }
                },
                const Center(child: Text('Download as PDF')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
