import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:bitsure/network/createwallet.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Loads wallet and returns clean xpubs
Future<Map<String, dynamic>> loadWallet(Network network) async {
  final secureStorage = const FlutterSecureStorage();
  final mnemonicStr = await secureStorage.read(key: 'users_mnemonics');

  if (mnemonicStr == null) {
    throw Exception("No wallet found locally");
  }

  final mnemonic = await Mnemonic.fromString(mnemonicStr);
  final descriptorSecretKey = await DescriptorSecretKey.create(
    network: network,
    mnemonic: mnemonic,
  );

  final externalDescriptor = await Descriptor.newBip44(
    secretKey: descriptorSecretKey,
    network: network,
    keychain: KeychainKind.External,
  );

  final internalDescriptor = await Descriptor.newBip44(
    secretKey: descriptorSecretKey,
    network: network,
    keychain: KeychainKind.Internal,
  );

  final String externalRaw = await externalDescriptor.asString();
  final String internalRaw = await internalDescriptor.asString();

  print('External Descriptor: $externalRaw');
  print('Internal Descriptor: $internalRaw');

  try {
    final String externalXpub = _extractXpubFromDescriptor(externalRaw);
    final String internalXpub = _extractXpubFromDescriptor(internalRaw);

    return {
      'externalDescriptor': externalXpub,
      'internalDescriptor': internalXpub,
    };
  } catch (e, stacktrace) {
    print(' Failed to extract xpub: $e');
    print(stacktrace);
    throw Exception('Failed to extract xpub from descriptor');
  }
}

/// Extracts raw tpub string from descriptor format becauses while on network.testnet bdk_flutter runs tpub

String _extractXpubFromDescriptor(String descriptor) {
  if (descriptor.isEmpty) {
    throw Exception('Descriptor is empty');
  }

  final regex = RegExp(r'\[.*?\]([a-z]pub[0-9A-Za-z]+)');
  final match = regex.firstMatch(descriptor);

  if (match != null && match.groupCount >= 1) {
    return match.group(1)!;
  } else {
    print(' Descriptor did not match regex: $descriptor');
    throw Exception('Failed to extract xpub/tpub from descriptor');
  }
}


/// Generates or retrieves a stored user ID
Future<String> getOrCreateUserId() async {
  final storage = const FlutterSecureStorage();
  const key = 'user_id';

  String? userId = await storage.read(key: key);
  if (userId != null) return userId;

  userId = const Uuid().v4();
  await storage.write(key: key, value: userId);
  return userId;
}

/// Register user with backend using raw xpubs
Future<void> registerUserOnBackend(Network network) async {
  final userId = await getOrCreateUserId();
  final secureStorage = const FlutterSecureStorage();

  Map<String, dynamic> walletData;
  final hasWallet = await secureStorage.read(key: 'users_mnemonics') != null;

  if (hasWallet) {
    walletData = await loadWallet(network);
  } else {
    walletData = await createWallet(network);
  }

  final payload = {
    'user_id': userId,
    'external_descriptor': walletData['externalDescriptor'],
    'internal_descriptor': walletData['internalDescriptor'],
  };

  print('Sending payload to backend: $payload');
  await sendToBackend(payload);
}

/// Sends user ID and xpubs to backend
Future<void> sendToBackend(Map<String, dynamic> payload) async {
  const String url = 'https://your-backend-api.com/register'; 

  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(payload),
  );

  if (response.statusCode != 200) {
    print('Backend response: ${response.statusCode} ${response.body}');
    throw Exception('Failed to register user on backend');
  } else {
    print(' Successfully registered user on backend');
  }
}
