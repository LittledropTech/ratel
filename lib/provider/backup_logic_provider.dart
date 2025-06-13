import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:bitsure/auth/google_auth.dart';

import 'package:bitsure/subscreens/passwordscreen.dart';
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
  final googleSignIn = GoogleSignIn(scopes: [drive.DriveApi.driveFileScope]);

  Future<GoogleSignInAccount?> signInWithGoogle() async {
    // Always sign out to force Google account picker and consent dialog
    await googleSignIn.signOut();
    final GoogleSignInAccount? account = await googleSignIn.signIn();
    return account;
  }

  Future<String?> promptPassword(BuildContext context,String text,String pagetext,String subtext)async {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return   PasswordScreen(text: text,pagetext:pagetext,subpagetext: subtext,);
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

  Map<String, String> encryptSeed(String password, List<String> seed) {
    final seedString = seed.join(' ');
    final salt = generateSalt();
    final iv = encrypt.IV.fromLength(16);
    final key = deriveKey(password, salt);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(seedString, iv: iv);

    return {
      "ciphertext": encrypted.base64,
      "salt": salt,
      "iv": base64Encode(iv.bytes),
    };
  }

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
   
Future<String?> generatePoemTxtAndSave(String poem) async {
  try {
    const fileName = 'My_Meme_Poem.txt';

    // Request permission
    final hasPermission = await _requestStoragePermission();
    debugPrint("🔐 Permission granted: $hasPermission");

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

        final fallbackPath = baseDir.path.replaceFirst(RegExp(r'Android.*'), 'Documents');
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

  Future<void> uploadToGoogleDrive(
    String encryptedData,
    String filename,
  ) async {
    try {
      print("Starting Google Drive upload");

      final account = await googleSignIn.signIn();

      if (account == null) {
        print("User cancelled sign-in.");
        return;
      }

      print("Signed in as: ${account.email}");

      final authHeaders = await account.authHeaders;
      final authenticateClient = GoogleAuthClient(authHeaders);
      final driveApi = drive.DriveApi(authenticateClient);

      final mediaBytes = utf8.encode(encryptedData);
      final mediaStream = http.ByteStream.fromBytes(mediaBytes);
      final media = drive.Media(mediaStream, mediaBytes.length);
      final file = drive.File()..name = filename;

      final response = await driveApi.files.create(file, uploadMedia: media);
      print(" File uploaded to Google Drive with ID: ${response.id}");
    } catch (e, stack) {
      print(" Upload error: $e");
      print("🪵 Stack trace: $stack");
    }
  }

  String decryptSeed(Map<String, String> encryptedMap, String password) {
    final salt = encryptedMap['salt']!;
    final iv = encrypt.IV.fromBase64(encryptedMap['iv']!);
    final ciphertext = encryptedMap['ciphertext']!;
    final key = deriveKey(password, salt);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    return encrypter.decrypt64(ciphertext, iv: iv);
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
       q: "name contains 'BitSure_MemePoem_Backup_' and mimeType = 'text/plain'",
      spaces: 'drive',
    );

    if (fileList.files == null || fileList.files!.isEmpty) {
      print("No backup file found.");
      return null;
    }

    final fileId = fileList.files!.first.id;
    final media = await driveApi.files.get(
      fileId!,
      downloadOptions: drive.DownloadOptions.fullMedia,
    ) as drive.Media;

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

}



