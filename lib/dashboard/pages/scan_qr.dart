import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';


class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  bool _scanned = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text('Scan QR Code'), backgroundColor: Colors.transparent, foregroundColor: Colors.white,),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth * 0.5;
          final double height = width;
          final double left = (constraints.maxWidth - width) / 2;
          final double top = (constraints.maxHeight - height) / 2;

          final Rect scanWindow = Rect.fromLTWH(left, top, width, height);
          return Stack(
            children: [
              MobileScanner(
                controller: MobileScannerController(),
                scanWindow: scanWindow,
                onDetect: (capture) {
                  final barcode = capture.barcodes.first;
                  final code = barcode.rawValue;
                  if (!_scanned && code != null) {
                    _scanned = true;
                    Navigator.pop(context, code);
                  }
                },
              ),
              Positioned.fill(
                child: ClipPath(
                  clipper: ScannerOverlayClipper(scanWindow: scanWindow),
                  child: Container(color: Colors.transparent),
                ),
              ),
              Positioned(
                left: scanWindow.left,
                top: scanWindow.top,
                child: Container(
                  width: scanWindow.width,
                  height: scanWindow.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ScannerOverlayClipper extends CustomClipper<Path> {
  final Rect scanWindow;

  ScannerOverlayClipper({required this.scanWindow});

  @override
  Path getClip(Size size) {
    final fullPath =
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final cutoutPath = Path()..addRect(scanWindow);
    return Path.combine(PathOperation.difference, fullPath, cutoutPath);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
