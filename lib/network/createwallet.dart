import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Creates a persistent BDK wallet:
/// - Generates a 12-word BIP39 mnemonic
/// - Derives BIP44 descriptors (external & internal)
/// - Stores mnemonic securely for wallet restoration
/// - Returns wallet metadata
Future<Map<String, dynamic>> createWallet(Network network) async {
  // 1. Generate 12-word mnemonic
  final mnemonic = await Mnemonic.create(WordCount.Words12);

  // 2. Store mnemonic securely (e.g., Android Keystore, iOS Keychain)
  const secureStorage = FlutterSecureStorage();
  await secureStorage.write(
    key: 'users_mnemonics',
    value: mnemonic.toString(),
  );

  // 3. Derive descriptor secret key
  final descriptorSecretKey = await DescriptorSecretKey.create(
    network: network,
    mnemonic: mnemonic,
  );

  // 4. Generate BIP44 descriptors
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

  // 5. Convert descriptors to strings
  final externalDescriptorStr = await externalDescriptor.asString();
  final internalDescriptorStr = await internalDescriptor.asString();

  // 6. Return result
  return {
    'mnemonics': mnemonic.toString(),
    'externalDescriptor': externalDescriptorStr,
    'internalDescriptor': internalDescriptorStr,
  };
}
