
// Wallet Card Widget
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../gen/assets.gen.dart';

class WalletCard extends StatelessWidget {
  final bool isMobile;
  const WalletCard({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    // Decorations for green leaves shapes - custom painter
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
                    child:  Text(
                      'Your Ratel Bag II',
                      style:  GoogleFonts.quicksand(
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
                        style:  GoogleFonts.quicksand(
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
