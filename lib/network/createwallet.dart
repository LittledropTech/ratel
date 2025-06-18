import 'dart:io';
import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

Future<Map<String, dynamic>> createWallet(Network network) async {
  final mnemonic = await Mnemonic.create(WordCount.Words12);
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

  final externalDescriptorStr = await externalDescriptor.asString();
  final internalDescriptorStr = await internalDescriptor.asString();

  const secureStorage = FlutterSecureStorage();
  await secureStorage.write(key: 'users_mnemonics', value: mnemonic.toString());
  await secureStorage.write(key: 'external_descriptor', value: externalDescriptorStr);
  await secureStorage.write(key: 'internal_descriptor', value: internalDescriptorStr);

  return {
    'mnemonics': mnemonic.toString(),
    'externalDescriptor': externalDescriptorStr,
    'internalDescriptor': internalDescriptorStr,
  };
}
