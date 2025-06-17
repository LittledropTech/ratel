import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';



//the fuctions that creates  wallets for every user
Future<Map<String,dynamic>> createWallet( Network network)async{

  final mnemonic = await Mnemonic.create(WordCount.Words12);
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    final descriptorSecretKey = await DescriptorSecretKey.create(network: network, mnemonic: mnemonic);
    final externalDescriptor = await  Descriptor.newBip44(secretKey: descriptorSecretKey, network: network, keychain: KeychainKind.External,);
    final internaldescriptor = await Descriptor.newBip44(secretKey: descriptorSecretKey, network: network, keychain: KeychainKind.Internal);
    final externalPublicDescriptorString = await externalDescriptor.asString();
    await secureStorage.write(key:'users_mnemonics' , value: mnemonic.toString());
    return {
      'mnemonics': mnemonic.toString(),
      "externalDescriptor":externalPublicDescriptorString,
      "internalDescriptor":internaldescriptor,
      'externalPublicDescriptorString':externalPublicDescriptorString,
      
    };

}


