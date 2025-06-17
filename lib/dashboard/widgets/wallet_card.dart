// Wallet Card Widget
import 'dart:developer';

import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:bitsure/dashboard/pages/bag/all_bags.dart';
import 'package:bitsure/utils/customutils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../gen/assets.gen.dart';

class WalletCard extends StatefulWidget {
  final bool isMobile;
  const WalletCard({required this.isMobile});

  @override
  State<WalletCard> createState() => _WalletCardState();
}

class _WalletCardState extends State<WalletCard> {
  @override
  void initState() {
    super.initState();
    _initializeWalletAndBalance();
  }

  Wallet? _wallet;
  int? _balanceSats;
  late Blockchain blockchain;
  bool _isLoading = true;
  String? displayText;
  String? address;
  String? balance;
  final network = Network.Testnet;

  Future<String> getNewAddress(Wallet? wallet) async {
    final addressInfo = await wallet?.getAddress(
      addressIndex: const AddressIndex.new(),
    );
    log(addressInfo!.address.toString());
    return addressInfo!.address.toString();
  }


  Future<void> syncWallet(Wallet wallet, {String? electrumUrl}) async {
  // Default Electrum server for testnet
  final defaultElectrumUrl = electrumUrl ?? 'ssl://electrum.blockstream.info:60002';
  
  final blockchain = await Blockchain.create(
    config: BlockchainConfig.electrum(
      config: ElectrumConfig(
        url: defaultElectrumUrl,
        socks5: null,
        retry: 5,
        timeout: 5,
        stopGap: 10,
        validateDomain: false,
      ),
    ),
  );
  
  await wallet.sync(blockchain);
}


  Future<void> _initializeWalletAndBalance() async {
    try {

      FlutterSecureStorage storage = const FlutterSecureStorage();
      String? mnemonicStr = await storage.read(key: 'users_mnemonics') ?? "";

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

      _wallet = await Wallet.create(
        descriptor: externalDescriptor,
        changeDescriptor: internalDescriptor,
        network: Network.Testnet,
        databaseConfig: const DatabaseConfig.memory(),
      );
      await syncWallet(_wallet!);
      final balance = await _wallet!.getBalance();
      setState(() {
        _balanceSats = balance.total;
        _isLoading = false;
      });

      getNewAddress(_wallet);
      
      log(_balanceSats.toString(), name: "Sats Balance");
   
      // syncWallet();
    } catch (e) {
      debugPrint('Error initializing wallet: $e');
      setState(() {
        _isLoading = false;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Custom green shapes painted top-left and bottom-right
            Positioned(
              top: 0,
              left: 22,
              child: Assets.images.walletLeafTop.image(
                width: 93.75,
                height: 62.75,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 10,
              child: Assets.images.walletLeafBottom.image(
                width: 93.75,
                height: 62.75,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dropdown label
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return AllBagsscreen();
                          },
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Your Ratel Bag II ',
                            style: GoogleFonts.quicksand(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white70,
                          ),
                        ],
                      ),
                    ),
                  ),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        '₿',
                        style: TextStyle(
                          fontSize: 56,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _isLoading
                            ? '...'
                            : (satsToBtc(_balanceSats?? 0) ).toStringAsFixed(
                                5,
                              ), // Convert sats to BTC
                        style: GoogleFonts.quicksand(
                          fontSize: 56,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 1),

                      const SizedBox(width: 8),
                      Icon(
                        Icons.visibility_outlined,
                        color: Colors.white,
                        size: 28,
                      ),
                    ],
                  ),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '= \$285.32 - Decent, not rich.',
                        style: GoogleFonts.quicksand(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Semantics(
                        label: 'Ratel coin emoji face',
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white),
                          ),

                          child: Image.asset(
                            Assets.meme1.path,
                            width: 24,
                            height: 24,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}