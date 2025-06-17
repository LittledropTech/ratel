import 'dart:developer';
import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:bitsure/profile/profile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../gen/assets.gen.dart';
import '../widgets/action_button.dart';
import '../widgets/recernt_chaos_list.dart';
import '../widgets/wallet_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Wallet? _wallet;
  int? _balanceSats;
  bool _isLoading = true;
  String? displayText;
  String? address;
  String? balance;
  final network = Network.Testnet;

  @override
  void initState() {
    super.initState();
    _initializeWalletAndBalance();
  }

  Future<String> getNewAddress(Wallet? wallet) async {
    final addressInfo = await wallet?.getAddress(
      addressIndex: const AddressIndex.new(),
    );
    log(addressInfo!.address.toString());
    return addressInfo.address.toString();
  }

  Future<void> syncWallet(Wallet wallet, {String? electrumUrl}) async {
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
    } catch (e) {
      debugPrint('Error initializing wallet: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 768;

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 16 : 50,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context, isMobile),
                      const SizedBox(height: 24),
                      WalletCard(isMobile: isMobile),
                      const SizedBox(height: 32),
                      Center(
                        child: Text(
                          '"Up 3% this week. You’re basically Warren Buffet"',
                          style: GoogleFonts.quicksand(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 32),
                      ActionButtons(),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                            children: [
                              if (_wallet != null) RecentChaosList(wallet: _wallet!),
                            ],
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Semantics(
            label: 'User profile picture',
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
              child: CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage(Assets.images.balablu.path),
                backgroundColor: Colors.grey.shade300,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, Onionsman',
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'GM Bestie, make the moves',
                  style: GoogleFonts.quicksand(
                    fontSize: 13,
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Assets.icons.solarBellLinear.svg(),
            iconSize: 28,
            color: Colors.black87,
            onPressed: () {
              // handle notifications pressed
            },
            tooltip: 'Notifications',
          ),
        ],
      );
}
