// Wallet Card Widget
import 'dart:developer';

import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../gen/assets.gen.dart';

class WalletCard extends StatefulWidget {
  final bool isMobile;
  const WalletCard({required this.isMobile});

  @override
  State<WalletCard> createState() => _WalletCardState();
}

class _WalletCardState extends State<WalletCard> {
  //   @override
  // void initState() {
  //   super.initState();
  //   _initializeWalletAndBalance();
  // }
  // Wallet? _wallet;
  // int? _balanceSats;
  // bool _isLoading = true;

  // Future<void> _initializeWalletAndBalance() async {
  //   try {
  //     // This assumes you already created descriptors
  //     final descriptor = await Descriptor.create(
  //       descriptor: 'wpkh([fingerprint/derivation]xpub/0/*)', // replace with actual
  //       network: Network.Testnet,
  //     );

  //     final changeDescriptor = await Descriptor.create(
  //       descriptor: 'wpkh([fingerprint/derivation]xpub/1/*)', // replace with actual
  //       network: Network.Testnet,
  //     );

  //     _wallet = await Wallet.create(
  //       descriptor: descriptor,
  //       changeDescriptor: changeDescriptor,
  //       network: Network.Testnet,
  //       databaseConfig: const DatabaseConfig.memory(),
  //     );

  //     final balance = await _wallet!.getBalance();
  //     setState(() {
  //       _balanceSats = balance.total;
  //       _isLoading = false;
  //     });

  //     log(_balanceSats.toString());
  //   } catch (e) {
  //     debugPrint('Error initializing wallet: $e');
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      'Your Ratel Bag II',
                      style: GoogleFonts.quicksand(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  // const SizedBox(height: 20),

                  // Bitcoin amount big text with eye icon inline
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
                      //                       Text(
                      //   _isLoading
                      //       ? '...'
                      //       : (_balanceSats! / 100000000).toStringAsFixed(8), // Convert sats to BTC
                      //   style: GoogleFonts.quicksand(
                      //     fontSize: 56,
                      //     color: Colors.white,
                      //     fontWeight: FontWeight.w600,
                      //   ),
                      // ),
                      // const SizedBox(width: 1),
                      Text(
                        '0.0042',
                        style: GoogleFonts.quicksand(
                          fontSize: 56,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.visibility_outlined,
                        color: Colors.white,
                        size: 28,
                      ),
                    ],
                  ),

                  // const SizedBox(height: 12),

                  // Converted amount with emoji image on right
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
