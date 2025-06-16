import 'package:bitsure/dashboard/pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:bdk_flutter/bdk_flutter.dart' as bdk;


import 'package:bitsure/utils/customutils.dart';
import 'package:bitsure/utils/theme.dart';

class ManualRestoreScreen extends StatefulWidget {
  const ManualRestoreScreen({super.key});

  @override
  State<ManualRestoreScreen> createState() => _ManualRestoreScreenState();
}

class _ManualRestoreScreenState extends State<ManualRestoreScreen> {
  final _formKey = GlobalKey<FormState>();
  final _seedPhraseController = TextEditingController();

  // The NEW main function that handles the logic using BDK
  Future<void> _verifyAndProceed() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final mnemonicString = _seedPhraseController.text.trim().toLowerCase();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final mnemonic = await bdk.Mnemonic.fromString(mnemonicString);
      print("BDK validation successful!");
      final words = mnemonicString.split(' ');
      await navigator.push(
        MaterialPageRoute(
          builder: (context) => DashboardScreen(),
        ),
      );
    } catch (e) {
      print("BDK Mnemonic validation failed: $e");

      // Show an error message to the user.
      messenger.showSnackBar(
         SnackBar(
          content: Text("Invalid seed phrase. Please check your words and try again."),
          backgroundColor: klightbluecolor,
        ),
      );
    }
  }
  
  @override
  void dispose() {
    _seedPhraseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text("Restore from Phrase")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Icon(Icons.edit_document, size: 80, ),
                const SizedBox(height: 20),
                const Text('Import Your Wallet', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Enter your 12 or 24-word secret recovery phrase below.', textAlign: TextAlign.center),
                const SizedBox(height: 45),
                
                TextFormField(
                  controller: _seedPhraseController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Secret Recovery Phrase',
                    hintText: 'word1 word2 word3...',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your seed phrase';
                    }
                    if (value.trim().split(' ').length < 12) {
                      return 'A valid seed phrase has at least 12 words.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 50),
                custombuttons(
                  50,
                  size.width * 0.9,
                  BoxDecoration(color: klightbluecolor, borderRadius: BorderRadius.circular(30)),
                  _verifyAndProceed,
                  const Center(child: Text("Import Wallet", style: TextStyle(color: Colors.white))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}