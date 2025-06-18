import 'dart:developer';

import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:bitsure/network/createwallet.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class WalletAuthProvdiver with  ChangeNotifier{
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
  return {
    'external_descriptor': externalRaw,
    'internal_descriptor': internalRaw,
  };
}

Future<String> getOrCreateUserId() async {
  final storage = const FlutterSecureStorage();
  const key = 'user_id';

  String? userId = await storage.read(key: key);
  if (userId != null) return userId;

  userId = const Uuid().v4();
  await storage.write(key: key, value: userId);
  return userId;
}


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
    'external_descriptor': walletData['external_descriptor'],
    'internal_descriptor': walletData['internal_descriptor'],
  };

  print('Sending payload to backend: $payload');
}



Future<List<TransactionDetails>> getTransactionHistory(Wallet wallet) async {
  log(wallet.listTransactions(false).toString());
  return await wallet.listTransactions(false);
}



}
