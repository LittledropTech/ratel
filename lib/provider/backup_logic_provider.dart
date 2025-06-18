import 'dart:convert';
import 'dart:math';
import 'package:bitsure/onboarding/auth/google_auth.dart';
import 'package:bitsure/onboarding/subscreens/passwordscreen.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:file_saver/file_saver.dart';

class BackupProvider with ChangeNotifier {
  final googleSignIn = GoogleSignIn(scopes: [drive.DriveApi.driveAppdataScope]);

  Future<GoogleSignInAccount?> signInWithGoogle() async {
    var account = await googleSignIn.signInSilently();
    account ??= await googleSignIn.signIn();
    return account;
  }


  Future<String?> promptPassword(
    BuildContext context,
    String text,
    String pagetext,
    String subtext,
  ) async {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return PasswordScreen(
            text: text,
            pagetext: pagetext,
            subpagetext: subtext,
          );
        },
      ),
    );
  }

  
  String generateSalt([int length = 16]) {
    final rand = Random.secure();
    return base64UrlEncode(
      List<int>.generate(length, (_) => rand.nextInt(256)),
    );
  }

  encrypt.Key deriveKey(String password, String salt) {
    final bytes = utf8.encode(password + salt);
    final hash = sha256.convert(bytes).bytes;
    return encrypt.Key(Uint8List.fromList(hash));
  }

 
  Map<String, String> encryptSeed(String password, List<String> seedPhrase) {
  
    final plainText = seedPhrase.join(' ');

    // Prepare the encryption key and a random IV.
    final key = encrypt.Key.fromUtf8(password.padRight(32).substring(0, 32));
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.cbc),
    );

   
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return {'iv': iv.base64, 'encryptedSeed': encrypted.base64};
  }

  String hashSeed(String password, List<String> seedPhrase) {
    final seedString = seedPhrase.join(' ');
    final combined = '$password:$seedString';
    final bytes = utf8.encode(combined);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
 
  String generateRandomPoem() {
    final lines = [
      "In shadows deep where secrets sleep,",
      "A spark is kept for you to keep.",
      "Mountains stand and rivers glide,",
      "But bits endure and truths won't hide.",
      "The sky may shift, the winds may roam,",
      "Yet you will always find your home.",
    ];
    lines.shuffle();
    return lines.take(4).join("\n");
  }
   Future<String?> generateAndSavePoemBackup({
  required String poem,
  required String password,
  required String seedPhrase,
}) async {
  try {
   
    final keyBytes = Uint8List(32);
    final passwordBytes = utf8.encode(password);
    keyBytes.setRange(0, passwordBytes.length < 32 ? passwordBytes.length : 32, passwordBytes);
    final key = encrypt.Key(keyBytes);
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final encryptedSeed = encrypter.encrypt(seedPhrase, iv: iv);
    final encryptedMap = {'iv': iv.base64, 'encryptedSeed': encryptedSeed.base64};
    final encryptedJson = jsonEncode(encryptedMap);
    final hiddenData = 'POEM_START:$encryptedJson:POEM_END';
    // Create pdf
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(30),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("Ratel Wallet - Encrypted Poem Backup", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Text(poem, style: const pw.TextStyle(fontSize: 16, lineSpacing: 5)),
                pw.SizedBox(height: 40),
                pw.Text("IMPORTANT SECURITY NOTICE:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.red800)),
                pw.SizedBox(height: 10),
                pw.Text("This file contains your encrypted backup. Store it securely and remember your password. The poem above is for identification only.", style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
                pw.Spacer(),
                pw.Text(hiddenData, style: const pw.TextStyle(fontSize: 0.1, color: PdfColors.white)),
              ],
            ),
          );
        },
      ),
    );
   
    final Uint8List pdfBytes = await pdf.save();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'Ratel_Backup_$timestamp.pdf';
    String? filePath = await FileSaver.instance.saveAs(
      name: fileName,
      bytes: pdfBytes,
      ext: 'pdf',
      mimeType: MimeType.pdf,
    );
    if (filePath != null) {
      debugPrint('PDF backup saved successfully at user-chosen location: $filePath');
    } else {
      debugPrint('User cancelled the save operation.');
    }
    return filePath;
  } catch (e, stackTrace) {
    debugPrint('Error during secure PDF backup generation: $e');
    debugPrint('Stack trace: $stackTrace');
    return null;
  }
}
  List<String> decryptSeed(String encryptedJson, String password) {
    try {
      // 1. Decode the JSON string back into a Map
      final encryptedMap = jsonDecode(encryptedJson) as Map<String, dynamic>;
      final ivBase64 = encryptedMap['iv'] as String;
      final encryptedSeedBase64 = encryptedMap['encryptedSeed'] as String;

      final key = encrypt.Key.fromUtf8(password.padRight(32).substring(0, 32));
      final iv = encrypt.IV.fromBase64(ivBase64);
      //  Create the AES decrypter
      final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc),
      );
      final encryptedObject = encrypt.Encrypted.fromBase64(encryptedSeedBase64);
      final decryptedString = encrypter.decrypt(encryptedObject, iv: iv);
      return decryptedString.split(',');
    } catch (e) {
      print("Decryption failed: $e");
      throw Exception("Invalid password or corrupted data.");
    }
  }
  static const String _folderName = 'Ratel Wallet';
  static const String _backupFilename = 'RatelWallet_backup.txt';

  Future<String?> _findOrCreateFolder(drive.DriveApi driveApi) async {
   
    final folderList = await driveApi.files.list(
      q: "name = '$_folderName' and mimeType = 'application/vnd.google-apps.folder' and trashed = false",
      $fields: 'files(id, name)',
    );

    if (folderList.files != null && folderList.files!.isNotEmpty) {
     
      print("Folder '$_folderName' found.");
      return folderList.files!.first.id;
    } else {
      
      print("Folder '$_folderName' not found, creating it...");
      final folderMetadata = drive.File()
        ..name = _folderName
        ..mimeType = 'application/vnd.google-apps.folder';
      final newFolder = await driveApi.files.create(folderMetadata);
      print("Folder created with ID: ${newFolder.id}");
      return newFolder.id;
    }
  }

  Future<List<String>?> findAndDecryptBackup(String password) async {
    try {
      print("Starting restore: finding all backups and trying password...");

      final account =
          await googleSignIn.signInSilently() ?? await googleSignIn.signIn();
      if (account == null) throw Exception("Google Sign-In failed.");

      final authHeaders = await account.authHeaders;
      final authenticateClient = GoogleAuthClient(authHeaders);
      final driveApi = drive.DriveApi(authenticateClient);

     
      final folderList = await driveApi.files.list(
        q: "name = '$_folderName' and mimeType = 'application/vnd.google-apps.folder' and trashed = false",
        $fields: 'files(id)',
      );

      if (folderList.files == null || folderList.files!.isEmpty) {
        throw Exception("Backup folder '$_folderName' not found.");
      }
      final folderId = folderList.files!.first.id!;

     
      final fileList = await driveApi.files.list(
        q: "name contains 'RatelWallet_backup' and '$folderId' in parents and trashed = false",
        $fields: 'files(id, name)',
      );

      if (fileList.files == null || fileList.files!.isEmpty) {
        throw Exception("No backup files found in the folder.");
      }

      for (final file in fileList.files!) {
        print("Attempting to decrypt file: ${file.name}...");

       
        final response =
            await driveApi.files.get(
                  file.id!,
                  downloadOptions: drive.DownloadOptions.fullMedia,
                )
                as drive.Media;
        final encryptedJson = await utf8.decodeStream(response.stream);

        try {
          final decryptedSeed = decryptSeed(encryptedJson, password);

          print("SUCCESS! Password matched for ${file.name}.");
          return decryptedSeed; 
        } catch (e) {
          print("Password did not match for ${file.name}. Trying next file...");
          continue; 
        }
      }

      print("Password did not match any of the backups found.");
      return null;
    } catch (e, stack) {
      print("An error occurred during the restore process: $e");
      print("Stack trace: $stack");
      
      throw Exception("Failed to restore from Google Drive: ${e.toString()}");
    }
  }

  
  Future<void> uploadToGoogleDrive(String encryptedData) async {
    try {
      print("Starting Google Drive backup...");

      final account =
          await googleSignIn.signInSilently() ?? await googleSignIn.signIn();
      if (account == null) {
        throw Exception("User cancelled sign-in.");
      }
      print("Signed in as: ${account.email}");
      final authHeaders = await account.authHeaders;
      final authenticateClient = GoogleAuthClient(authHeaders);
      final driveApi = drive.DriveApi(authenticateClient);

      
      final folderId = await _findOrCreateFolder(driveApi);
      if (folderId == null) {
        throw Exception("Could not find or create the backup folder.");
      }
      final timestamp = DateFormat(
        'yyyy-MM-dd_HH-mm-ss',
      ).format(DateTime.now());
      final uniqueFilename = 'RatelWallet_backup_$timestamp.txt';
      print("Creating new backup file: $uniqueFilename");
      final fileMetadata = drive.File()
        ..name = uniqueFilename
        ..parents = [folderId];
      final mediaBytes = utf8.encode(encryptedData);
      final mediaStream = http.ByteStream.fromBytes(mediaBytes);
      final media = drive.Media(mediaStream, mediaBytes.length);
      await driveApi.files.create(fileMetadata, uploadMedia: media);
      print("New backup file created successfully in '$_folderName'.");
    } catch (e, stack) {
      print("An error occurred during Google Drive upload: $e");
      print("Stack trace: $stack");
      throw Exception("Failed to upload backup to Google Drive.");
    }
  }
}
