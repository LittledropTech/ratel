import 'dart:developer';
import 'dart:io';

import 'package:bitsure/gen/assets.gen.dart';
import 'package:bitsure/utils/customutils.dart';
import 'package:bitsure/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:googleapis/appengine/v1.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class SatsSentBottomSheet extends StatelessWidget {
  final double amount;
  final String address;
  final double fee;
  final DateTime time;
  final String status;
  final String txid;
  final String network;

  SatsSentBottomSheet({
    super.key,

    required this.amount,
    required this.address,
    required this.fee,
    required this.time,
    required this.status,
    required this.txid,
    required this.network,
  });

  final ScreenshotController screenshotController = ScreenshotController();

  Future<void> captureAndShareImage(BuildContext context) async {
    // Get the device's pixel ratio to improve image quality
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    try {
      // Capture the screenshot with specified pixelRatio
      final imageBytes = await screenshotController.capture(
        pixelRatio: pixelRatio,
      );

      if (imageBytes != null) {
        // Get the application's documents directory
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}.png';
        final file = File(filePath);

        // Write the image file
        await file.writeAsBytes(imageBytes);

        // Share the image file
        await Share.shareXFiles([
          XFile(file.path),
        ], text: 'EKXPAY Transaction Receipt');
      } else {
        log('Failed to capture screenshot');
      }
    } catch (e) {
      log('Error capturing screenshot: $e');
    }
  }

  void onShare(BuildContext context) async {
    await captureAndShareImage(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Screenshot(
        controller: screenshotController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, size: 24),
                ),
                Text(
                  "Sats Sent, Vibes Delivered",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                SizedBox(width: 24), // to balance the close icon space
              ],
            ),
            const SizedBox(height: 24),
        
            // Star flower with circular image in the center
            Stack(
              children: [
                Positioned(
                  child: customcontainer(
                    200,
                    MediaQuery.sizeOf(context).width / 1.3,
                    BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(Assets.images.successStar.path),
                      ),
                    ),
                    const SizedBox(),
                  ),
                ),
                Positioned(
                  left: 15,
                  top: 10,
                  child: customcontainer(
                    200,
                    MediaQuery.sizeOf(context).width / 1.4,
                    BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(Assets.images.onPoint.path),
                      ),
                    ),
                    const SizedBox(),
                  ),
                ),
              ],
            ),
        
            const SizedBox(height: 24),
            const Text(
              "You Did it. Sats in Motion",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
        
            // Info rows
            _infoRow("Amount Sent", "$amount BTC (\$22.80)"),
            _infoRow("To", "$address"),
            _infoRow("Network Fee", "${fee.toStringAsFixed(8)} BTC"),
            _infoRow("Status", "Confirmed"),
            _infoRow("Time", formatDateTime(time)),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F6F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Onchain", style: const TextStyle(color: Colors.black54)),
                  GestureDetector(
                    onTap: () {
                      // Handle read more action
                      launchURL(
                        context,
                        network == 'testnet'
                            ? 'https://mempool.space/testnet/tx/$txid'
                            : 'https://mempool.space/tx/$txid',
                      );
                    },
                    child: Text(
                      'Verify trx',
                      style: GoogleFonts.quicksand(
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue,
                        color: Colors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        
            const SizedBox(height: 32),
        
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: klightbluecolor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(3, 4),
                          blurRadius: 2,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6F7EFF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        elevation: 4,
                      ),
                      onPressed: () {},
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'Back to bag',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: klightbluecolor,
                          offset: Offset(3, 4),
                          blurRadius: 2,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        elevation: 4,
                      ),
                      onPressed: () => onShare(context),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text('Receipt?'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
