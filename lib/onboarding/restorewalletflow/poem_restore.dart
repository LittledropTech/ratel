import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bitsure/onboarding/restorewalletflow/restore_new_code.dart';
import 'package:bitsure/utils/customutils.dart';
import 'package:bitsure/utils/textstyle.dart';
import 'package:bitsure/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:bdk_flutter/bdk_flutter.dart' as bdk;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PoemRestoreScreen extends StatefulWidget {
  const PoemRestoreScreen({super.key});
  @override
  State<PoemRestoreScreen> createState() => _PoemRestoreScreenState();
}

class _PoemRestoreScreenState extends State<PoemRestoreScreen> {
  bool _isLoading = false;
  Future<String?> _promptForPassword(BuildContext ctx) async {
    final ctrl = TextEditingController();
    return showDialog<String>(
      context: ctx,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Enter Password'),
        content: TextField(
          controller: ctrl,
          obscureText: true,
          autofocus: true,
          maxLength: 8,
          decoration: const InputDecoration(hintText: 'Backup password'),
        ),
        actions: [
          custombuttons(40, 500, BoxDecoration(
            color:klightbluecolor,
            borderRadius: BorderRadius.circular(10)
          ), (){
            Navigator.pop(ctx, ctrl.text.trim());
          }, Center(
            child: Text('Restore'),
          ))
        ],
      ),
    );
  }
  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }
  // Extracts hidden data using the Syncfusion PDF library.
  Future<String?> _findHiddenDataInPdf(Uint8List pdfBytes) async {
    try {
      final PdfDocument document = PdfDocument(inputBytes: pdfBytes);
      final PdfTextExtractor extractor = PdfTextExtractor(document);
      final String fullText = extractor.extractText();
      document.dispose();
      // Use the same regex to find the data within the extracted text.
      final RegExp regex = RegExp(r'POEM_START:(.*?):POEM_END', dotAll: true);
      final match = regex.firstMatch(fullText);
      return match?.group(1);
    } catch (e) {
      debugPrint("Error parsing PDF with Syncfusion: $e");
      return null;
    }
  }
  // Main workflow to import, decrypt, and restore the wallet.
  Future<void> _importAndProcessPoem() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result == null || result.files.isEmpty) return;
      final file = result.files.first;
      final pdfBytes = file.path != null ? await File(file.path!).readAsBytes() : file.bytes;
      if (pdfBytes == null) {
        _showError('Failed to read the backup file.');
        return;
      }
      final password = await _promptForPassword(context);
      if (password == null || password.isEmpty) return;
      final jsonStr = await _findHiddenDataInPdf(pdfBytes);
      if (jsonStr == null) {
        _showError('Backup data not found. The file may be invalid or corrupted.');
        return;
      }
      final Map<String, dynamic> data = jsonDecode(jsonStr);
      if (!data.containsKey('iv') || !data.containsKey('encryptedSeed')) {
        _showError('Backup file is missing required encryption data.');
        return;
      }
      final iv = encrypt.IV.fromBase64(data['iv']);
      final encryptedSeed = encrypt.Encrypted.fromBase64(data['encryptedSeed']);
      
      final keyBytes = Uint8List(32);
      final passwordBytes = utf8.encode(password);
      keyBytes.setRange(0, passwordBytes.length < 32 ? passwordBytes.length : 32, passwordBytes);
      final key = encrypt.Key(keyBytes);
      final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
      late final String mnemonic;
      try {
        mnemonic = encrypter.decrypt(encryptedSeed, iv: iv).trim();
      } catch (e) {
        _showError('Decryption failed. Please check your password.');
        return;
      }
      await bdk.Mnemonic.fromString(mnemonic);
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => RestoreNewCode()),
        (route) => false,
      );
    } catch (e) {
      _showError('An error occurred: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  @override
  Widget build(BuildContext ctx) {
    final size = MediaQuery.of(ctx).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Restore from Backup'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            SizedBox(
              height: 70,
            ),
              Text(
                'Select your encrypted PDF backup to restore your wallet.',
                textAlign: TextAlign.center,
                style: vsub1titletextstyle,
              ),
              const SizedBox(height: 30),
              if (_isLoading)
                Column(
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text('Processing backup...'),
                  ],
                )
              else
                GestureDetector(
                  onTap: _importAndProcessPoem,
                  child: customcontainer(
                    250,
                    size.width * 0.7,
                    BoxDecoration(
                      border: Border.all(color: klightbluecolor, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_file_rounded, size: 60, color: klightbluecolor),
                        const SizedBox(height: 20),
                        const Text(
                          'Tap to select backup PDF',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  'You will be asked for the password you used during backup.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
