import 'dart:convert';
import 'dart:developer';

import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:bitsure/dashboard/pages/bag/all_bags.dart';
import 'package:bitsure/provider/networkprovider.dart';
import 'package:bitsure/utils/customutils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../gen/assets.gen.dart';

class WalletCard extends StatefulWidget {
  final bool isMobile;
  const WalletCard({required this.isMobile,});

  @override
  State<WalletCard> createState() => _WalletCardState();
}

class _WalletCardState extends State<WalletCard> {
  Wallet? _wallet;
  int? _balanceSats;
  bool _isLoading = true;
  String? address;
  double _btcToUsdRate = 0;
   late final Network network;
  bool isloaded = true;

  @override
  void initState() {
    network = context.read<NetworkProvider>().network;
    super.initState();
    _initializeWalletAndBalance();
  }


  Future<String> _getDatabasePath() async {
  final directory = await getApplicationDocumentsDirectory();
  final dbPath = '${directory.path}/bdk_wallet.db';
  return dbPath;
}

Future<void> _initializeWalletAndBalance() async {
  try {
    const storage = FlutterSecureStorage();
    String? mnemonicStr = await storage.read(key: 'users_mnemonics');

    if (mnemonicStr == null || mnemonicStr.isEmpty) {
      // ❌ Do not auto-create a wallet here
      debugPrint("No mnemonic found — wallet not initialized.");
      setState(() => _isLoading = false);
      return;
    }

    // ✅ Restore wallet from saved mnemonic
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

final dbPath = await _getDatabasePath();
_wallet = await Wallet.create(
  descriptor: externalDescriptor,
  changeDescriptor: internalDescriptor,
  network: network,
  databaseConfig: DatabaseConfig.sqlite(config: SqliteDbConfiguration(path: dbPath)),
);


    await _syncWallet(_wallet!);

    final balance = await _wallet!.getBalance();
    final addrInfo = await _wallet!.getAddress(addressIndex: const AddressIndex.new());

    await _fetchBtcToUsdRate();

    setState(() {
      _balanceSats = balance.total;
      address = addrInfo.address;
      _isLoading = false;
    });

    log('Wallet restored');
  } catch (e, st) {
    debugPrint('Wallet restore failed: $e');
    log('Wallet restore error', error: e, stackTrace: st);
    setState(() => _isLoading = false);
  }
}



  Future<void> _syncWallet(Wallet wallet, {String? electrumUrl}) async {
    final url = electrumUrl ?? 'ssl://electrum.blockstream.info:60002';
    final blockchain = await Blockchain.create(
      config: BlockchainConfig.electrum(
        config: ElectrumConfig(
          url: url,
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

  Future<void> _fetchBtcToUsdRate() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _btcToUsdRate = data['bitcoin']['usd']?.toDouble() ?? 0;
        });
      }
    } catch (e) {
      log("Failed to fetch BTC price: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final btcAmount = satsToBtc(_balanceSats ?? 0);
    final usdEquivalent = (_btcToUsdRate * btcAmount).toStringAsFixed(2);

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AllBagsscreen()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                          const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                     isloaded?   _isLoading ? '...' : btcAmount.toStringAsFixed(5): '',
                        style: GoogleFonts.quicksand(
                          fontSize: 56,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: (){
                          setState(() {
                            isloaded = !isloaded;
                          });
                        },
                        child:  Icon( isloaded? Icons.visibility_outlined: Icons.visibility_off, color: Colors.white, size: 28)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (!_isLoading && address != null)
                    SelectableText(
                      address!,
                      style: GoogleFonts.quicksand(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isLoading ? '= ...' : '= \$$usdEquivalent',
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
