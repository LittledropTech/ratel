import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:bitsure/network/createwallet.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';




class WalletAuthProvdiver with  ChangeNotifier{
  /// Loads existing wallet and returns full external & internal descriptors
Future<Map<String, dynamic>> loadWallet(Network network) async {
  final secureStorage = const FlutterSecureStorage();
  final mnemonicStr = await secureStorage.read(key: 'users_mnemonics');

  if (mnemonicStr == null) {
    throw Exception("No wallet found in secure storage");
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

  print('✅ External Descriptor: $externalRaw');
  print('✅ Internal Descriptor: $internalRaw');

  return {
    'external_descriptor': externalRaw,
    'internal_descriptor': internalRaw,
  };
}

/// Generates or retrieves a stored UUIDv4 for the user
Future<String> getOrCreateUserId() async {
  final storage = const FlutterSecureStorage();
  const key = 'user_id';

  String? userId = await storage.read(key: key);
  if (userId != null) return userId;

  userId = const Uuid().v4();
  await storage.write(key: key, value: userId);
  return userId;
}

/// Registers the user on your backend with full descriptors
Future<void> registerUserOnBackend(Network network) async {
  final userId = await getOrCreateUserId();
  final secureStorage = const FlutterSecureStorage();

  Map<String, dynamic> walletData;
  final hasWallet = await secureStorage.read(key: 'users_mnemonics') != null;

  if (hasWallet) {
    walletData = await loadWallet(network);
  } else {
    walletData = await createWallet(network); // Ensure `createWallet` also returns descriptors
  }

  final payload = {
    'user_id': userId,
    'external_descriptor': walletData['external_descriptor'],
    'internal_descriptor': walletData['internal_descriptor'],
  };

  print('🚀 Sending payload to backend: $payload');
  await sendToBackend(payload);
}

/// Sends user ID and full descriptors to your backend
Future<void> sendToBackend(Map<String, dynamic> payload) async {
  //sending my users decriptor to the backend 
  const String url = 'https://test-api-ratle.littledrop.co'; 

  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(payload),
  );

  if (response.statusCode != 200 && response.statusCode ==201) {
    throw Exception('Failed to register user on backend: with statusCode ${response.statusCode}:with body ${response.body}');
  } else {
    print('Successfully registered user on backend');
  }
}


}
