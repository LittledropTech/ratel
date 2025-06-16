import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:bitsure/utils/theme.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image/image.dart' as img;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:bitsure/dashboard/pages/emoji_selector.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../gen/assets.gen.dart';

class ReceiveBitcoinScreen extends StatefulWidget {
  const ReceiveBitcoinScreen({super.key});

  @override
  State<ReceiveBitcoinScreen> createState() => _ReceiveBitcoinScreenState();
}

class _ReceiveBitcoinScreenState extends State<ReceiveBitcoinScreen> {
  final String userBitcoinAddress = "gstr27467289834tyghsoiwehjdf";
  final TextEditingController amountController = TextEditingController();
  final ScreenshotController screenshotController = ScreenshotController();
  Future<void> onDownload(BuildContext context) async {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    try {
      final imageBytes = await screenshotController.capture(
        pixelRatio: pixelRatio,
      );

      if (imageBytes != null) {
        Directory directory;

        if (Platform.isIOS) {
          // Use application documents directory on iOS
          directory = await getApplicationDocumentsDirectory();
        } else if (Platform.isAndroid) {
          // Use external storage directory on Android
          directory = (await getExternalStorageDirectory())!;
        } else {
          throw UnsupportedError("Unsupported platform");
        }

        final filePath = '${directory.path}/monieboxx_receipt.png';
        final file = File(filePath);

        // Write the image file
        await file.writeAsBytes(imageBytes);
        // print('Image saved at: $filePath');

        // Open the file
        final result = await OpenFile.open(filePath);

        if (result.type != ResultType.done) {
          // print('Error opening file: ${result.message}');
        }
      } else {
        // print('Failed to capture screenshot');
      }
    } catch (e) {
      // print('Error capturing screenshot: $e');
    }
  }

  // void onShare(BuildContext context) async {
  //   await captureAndShareImage(context);
  // }

  void _shareAsEmoji() {
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(48)),
  ),
  builder: (context) => Material(
    borderRadius: BorderRadius.vertical(top: Radius.circular(48)),
    child: SizedBox(
      height: 700, // Desired height
      child: EmojiSelectorScreen(),
    ),
  ),
);

  }

  void _shareAddress() {
    final amount = amountController.text.trim();
    String message = "Send Bitcoin to: $userBitcoinAddress";
    if (amount.isNotEmpty) {
      message += "\nAmount: $amount BTC";
    }

    Share.share(message);
  }

  void _fillAmount(String amount) {
    setState(() {
      amountController.text = amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = GoogleFonts.quicksand(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.black87,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kwhitecolor,
        elevation: 0,
        title: Text(
          "Get Bitcoin gold gang",
          style: titleStyle.copyWith(fontSize: 24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Screenshot(
                  controller: screenshotController,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        Assets.images.jamesTheBond.path,
                        fit: BoxFit.contain,
                      ),
                      Positioned(
                        top: 190,
                        left: 110,
                        child: QrImageView(
                          data: userBitcoinAddress,
                          version: QrVersions.auto,
                          size: 152.0,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: InkWell(
                  onTap: () => onDownload(context),
                  child: Text(
                    "Download code",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Your Bitcoin address",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  hintText: userBitcoinAddress,
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.copy),
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(text: userBitcoinAddress),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Address copied to clipboard'),
                        ),
                      );
                    },
                  ),
                ),
                readOnly: true,
              ),

              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: Colors.amber[200],
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black87,
                        offset: Offset(4, 4),
                        blurRadius: 0,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _shareAsEmoji,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Share as an Emoji 😉",
                      style: GoogleFonts.quicksand(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Request a specific amount (Optional btw)",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: amountController,
                decoration: InputDecoration(
                  hintText: "0.00",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(
                  spacing: 8.0,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AmountButton(amount: "0.001", onTap: _fillAmount),
                    AmountButton(amount: "0.005", onTap: _fillAmount),
                    AmountButton(amount: "0.01", onTap: _fillAmount),
                    AmountButton(amount: "0.05", onTap: _fillAmount),
                  ],
                ),
              ),
              SizedBox(height: 32),
              Container(
                width: MediaQuery.sizeOf(context).width * .9,
                decoration: BoxDecoration(
                  color: klightbluecolor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(3, 4),
                      blurRadius: 2,
                      spreadRadius: 2,
                      blurStyle: BlurStyle.solid,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _shareAddress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text(
                    "Share your address",
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class AmountButton extends StatelessWidget {
  final String amount;
  final void Function(String) onTap;

  const AmountButton({required this.amount, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black87,
            offset: Offset(4, 4),
            blurRadius: 0,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => onTap(amount),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          amount,
          style: GoogleFonts.quicksand(color: Colors.grey[700]),
        ),
      ),
    );
  }
}
