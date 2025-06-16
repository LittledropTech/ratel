import 'dart:async';
import 'dart:math';
import 'package:bitsure/utils/theme.dart';
import 'package:flutter/material.dart';

class BouncingImagesScreen extends StatefulWidget {
  const BouncingImagesScreen({super.key});

  @override
  State<BouncingImagesScreen> createState() => _BouncingImagesScreenState();
}

class _BouncingImagesScreenState extends State<BouncingImagesScreen> {
  final double containerHeight = 500;
  final double imageSize = 100;

  final Random _random = Random();

  // Initial positions
  double image1Top = 20;
  double image1Left = 300;

  double image2Top = 380;
  double image2Left = 20;

  // Original positions for return
  late double originalTop1;
  late double originalLeft1;
  late double originalTop2;
  late double originalLeft2;

  late Timer _timer;

  @override
  void initState() {
    super.initState();

    // Save original positions
    originalTop1 = image1Top;
    originalLeft1 = image1Left;
    originalTop2 = image2Top;
    originalLeft2 = image2Left;

    // Set up periodic movement
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      _moveImagesRandomly();
      Future.delayed(const Duration(seconds: 2), () {
        _returnImagesToOriginal();
      });
    });
  }

  void _moveImagesRandomly() {
    setState(() {
      image1Top = _random.nextDouble() * (containerHeight - imageSize);
      image1Left =
          _random.nextDouble() *
          (MediaQuery.of(context).size.width - imageSize);

      image2Top = _random.nextDouble() * (containerHeight - imageSize);
      image2Left =
          _random.nextDouble() *
          (MediaQuery.of(context).size.width - imageSize);
    });
  }

  void _returnImagesToOriginal() {
    setState(() {
      image1Top = originalTop1;
      image1Left = originalLeft1;
      image2Top = originalTop2;
      image2Left = originalLeft2;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget bouncingContainer(String imagePath) {
    return Container(
      height: imageSize,
      width: imageSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          height: containerHeight,
          width: double.infinity,
          color: Colors.transparent,
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(seconds: 2),
                top: image1Top,
                left: image1Left,
                child: RepaintBoundary(
                  child: bouncingContainer("assets/meme1.png"),
                ),
              ),

              AnimatedPositioned(
                duration: const Duration(seconds: 2),
                top: image2Top,
                left: image2Left,
                child: RepaintBoundary(
                  child: bouncingContainer("assets/meme2.png"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
