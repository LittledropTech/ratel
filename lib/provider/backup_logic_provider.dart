import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:bitsure/onboarding/auth/google_auth.dart';
import 'package:bitsure/onboarding/subscreens/passwordscreen.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class BackupProvider with ChangeNotifier {
  final googleSignIn = GoogleSignIn(scopes: [drive.DriveApi.driveAppdataScope]);

  Future<GoogleSignInAccount?> signInWithGoogle() async {
   var account = await googleSignIn.signInSilently();
    account ??= await googleSignIn.signIn();
    return account;
  }
  

//open the password screen for set password which will be encrypted
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

// generate salt for my users encrypted seedphrase+password
  String generateSalt([int length = 16]) {
    final rand = Random.secure();
    return base64UrlEncode(
      List<int>.generate(length, (_) => rand.nextInt(256)),);}
  encrypt.Key deriveKey(String password, String salt) {
    final bytes = utf8.encode(password + salt);
    final hash = sha256.convert(bytes).bytes;
    return encrypt.Key(Uint8List.fromList(hash));
  }
// encrypt My users seed phrase
Map<String, String> encryptSeed(String password, List<String> seedPhrase) {
  // Join the list of words into a single string.
  final plainText = seedPhrase.join(',');

  // Prepare the encryption key and a random IV.
  final key = encrypt.Key.fromUtf8(password.padRight(32).substring(0, 32));
  final iv = encrypt.IV.fromLength(16);
  final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  
  // Encrypt the data.
  final encrypted = encrypter.encrypt(plainText, iv: iv);
  return {
    'iv': iv.base64,
    'encryptedSeed': encrypted.base64,
  };
}
    //hash my users seedphrase +password
  String hashSeed(String password, List<String> seedPhrase) {
    final seedString = seedPhrase.join(' ');
    final combined = '$password:$seedString';
    final bytes = utf8.encode(combined);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Generate a random poem
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
// save the gernerated radom poem n save as PDF
  Future<String?> generatePoemTxtAndSave(String poem) async {
    try {
      const fileName = 'My_Meme_Poem.txt';

      // Request permission
      final hasPermission = await _requestStoragePermission();
      debugPrint(" Permission granted: $hasPermission");

      if (!hasPermission) {
        debugPrint("Storage permission not granted. Opening settings...");
        await openAppSettings();
        return null;
      }

      Directory dir;

      if (Platform.isAndroid) {
        // Try the standard Downloads folder path
        dir = Directory('/storage/emulated/0/Documents');

        if (!await dir.exists()) {
          debugPrint("Download folder not found. Falling back...");
          final baseDir = await getExternalStorageDirectory();
          if (baseDir == null) {
            debugPrint("Could not get external directory.");
            return null;
          }

          final fallbackPath = baseDir.path.replaceFirst(
            RegExp(r'Android.*'),
            'Documents',
          );
          dir = Directory(fallbackPath);

          if (!await dir.exists()) {
            await dir.create(recursive: true);
          }
        }
      } else if (Platform.isIOS) {
        dir = await getApplicationDocumentsDirectory();
      } else {
        dir = await getDownloadsDirectory() ?? Directory.systemTemp;
      }

      final file = File('${dir.path}/$fileName');
      await file.writeAsString(poem);

      if (await file.exists()) {
        debugPrint(" Poem saved successfully to: ${file.path}");
        return file.path;
      } else {
        debugPrint("File not found after saving.");
        return null;
      }
    } catch (e, stackTrace) {
      debugPrint("Error saving file: $e\n$stackTrace");
      return null;
    }
  }
// Obtaining request from  platform Permisssions
  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (sdkInt >= 30) {
        final status = await Permission.manageExternalStorage.request();
        if (status.isGranted) return true;
      } else {
        final status = await Permission.storage.request();
        if (status.isGranted) return true;
      }

      return false;
    }
    return true;
  }

 // Uplaod my users Encrypted seedPharse+password to goggle drive
Future<void> uploadToGoogleDrive(String encryptedData) async {
  try {
    print("Starting Google Drive backup to hidden App Data folder...");

  
    // This will only prompt the user if they are not already signed in.
    final account = await googleSignIn.signInSilently() ?? await googleSignIn.signIn();

    if (account == null) {
      print("User cancelled sign-in or failed to sign in.");
      // You might want to throw an exception here or show a message to the user
      return;
    }

    print("Signed in as: ${account.email}");

    final authHeaders = await account.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);

    //  USE A FIXED FILENAME
    // This is the single, predictable name we will look for during restore.
    const String backupFilename = 'bitsure_wallet_backup.dat';

    // CHECK IF THE FILE ALREADY EXISTS in the appDataFolder
    // This is the most critical step.
    final fileList = await driveApi.files.list(
      q: "name = '$backupFilename'",
      spaces: 'appDataFolder', 
      $fields: 'files(id)',    
    );

    // Prepare the media content for upload
    final mediaBytes = utf8.encode(encryptedData);
    final mediaStream = http.ByteStream.fromBytes(mediaBytes);
    final media = drive.Media(mediaStream, mediaBytes.length);
    
    // Prepare the file metadata
    final fileMetadata = drive.File()..name = backupFilename;

    // . DECIDE WHETHER TO UPDATE OR CREATE
    if (fileList.files != null && fileList.files!.isNotEmpty) {
      // FILE EXISTS: UPDATE IT 
      final fileId = fileList.files!.first.id!;
      print("Found existing backup file with ID: $fileId. Updating it...");
      await driveApi.files.update(fileMetadata, fileId, uploadMedia: media);
      print("Backup file successfully updated.");
      
    } else {
      // FILE DOES NOT EXIST: CREATE IT -
      print("No existing backup file found. Creating a new one...");
      
      fileMetadata.parents = ['appDataFolder'];
      final response = await driveApi.files.create(fileMetadata, uploadMedia: media);
      print("New backup file created with ID: ${response.id}");
    }

  } catch (e, stack) {
    print("Upload error: $e");
    print("Stack trace: $stack");
  
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
      final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
      final encryptedObject = encrypt.Encrypted.fromBase64(encryptedSeedBase64);
      final decryptedString = encrypter.decrypt(encryptedObject, iv: iv);
      return decryptedString.split(',');
    } catch (e) {
      print("Decryption failed: $e");
      throw Exception("Invalid password or corrupted data.");
    }
  }

  // retrieve the users encryptedSeedFormGoogle
  Future<Map<String, String>?> retrieveEncryptedSeedFromGoogleDrive() async {

    try {
      final account = await googleSignIn.signIn();
      if (account == null) return null;

      final authHeaders = await account.authHeaders;
      final authenticateClient = GoogleAuthClient(authHeaders);
      final driveApi = drive.DriveApi(authenticateClient);

      // Find the file by name
      final fileList = await driveApi.files.list(
        q: "name contains 'Rartel_Wallet_' and mimeType = 'text/plain'",
        spaces: 'drive',
      );

      if (fileList.files == null || fileList.files!.isEmpty) {
        print("No backup file found.");
        return null;
      }

      final fileId = fileList.files!.first.id;
      final media =
          await driveApi.files.get(
                fileId!,
                downloadOptions: drive.DownloadOptions.fullMedia,
              )
              as drive.Media;

      final content = <int>[];
      await for (final data in media.stream) {
        content.addAll(data);
      }

      final jsonString = utf8.decode(content);
      final decoded = json.decode(jsonString);

      return {
        'ciphertext': decoded['ciphertext'],
        'salt': decoded['salt'],
        'iv': decoded['iv'],
      };
    } catch (e, stack) {
      print("Error retrieving encrypted seed: $e\n$stack");
      return null;
    }
  }
  
  //  trying to decrypt encrypted seedphrase+password for easy recovery of wallet
   Future<String?> downloadEncryptedBackup() async {
    final account = await signInWithGoogle();
    if (account == null) {
      throw Exception("Google Sign-In failed or was cancelled.");
    }
    print("Signed in as ${account.email}");

    final authHeaders = await account.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);
    const String backupFilename = 'bitsure_wallet_backup.dat';

    // Search for the file only in the hidden App Data folder
    final fileList = await driveApi.files.list(
      q: "name = '$backupFilename'",
      spaces: 'appDataFolder',
      $fields: 'files(id, name)',
    );

    if (fileList.files == null || fileList.files!.isEmpty) {
      throw Exception("No backup found on this Google account.");
    }
    
    final fileId = fileList.files!.first.id!;
    print("Backup file found. Downloading...");

    // Download the full media content of the file
    final response = await driveApi.files.get(
      fileId,
      downloadOptions: drive.DownloadOptions.fullMedia,
    ) as drive.Media;

    // Decode the downloaded content into a string
    final encryptedJson = await utf8.decodeStream(response.stream);
    print("Encrypted data downloaded$encryptedJson.");
    return encryptedJson;
  }

}
