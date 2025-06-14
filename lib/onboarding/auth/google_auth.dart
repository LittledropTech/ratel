import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;

/// Custom AuthClient using headers from GoogleSignIn
class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}

/// Upload encrypted content to Google Drive with given filename
Future<void> uploadToGoogleDrive(String encryptedData, String filename) async {
  try {
    final googleSignIn = GoogleSignIn(
      clientId: '1093704872590-ff476ukkif5jt2tb4k4d5nqprq1akrsh.apps.googleusercontent.com', //My client ID
      scopes: [drive.DriveApi.driveFileScope],
    );

    final account = await googleSignIn.signIn();
    if (account == null) {
      debugPrint(" User canceled sign-in.");
      return;
    }

    final authHeaders = await account.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);

    final mediaBytes = utf8.encode(encryptedData);
    final mediaStream = http.ByteStream.fromBytes(mediaBytes);
    final media = drive.Media(mediaStream, mediaBytes.length);

    final file = drive.File();
    file.name = filename;

    final response = await driveApi.files.create(file, uploadMedia: media);
  } catch (e) {
    debugPrint(" Google Drive upload failed: $e");
  }
}
