import 'dart:io';

import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:bitsure/dashboard/dashboard.dart';
import 'package:provider/provider.dart';
import '../../provider/wallet_authprovider.dart';
import 'package:bitsure/utils/customutils.dart';
import 'package:bitsure/utils/textstyle.dart';
import 'package:bitsure/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';

class Createpinscreen extends StatefulWidget {
  const Createpinscreen({super.key});

  @override
  State<Createpinscreen> createState() => _CreatepinscreenState();
}

class _CreatepinscreenState extends State<Createpinscreen> {
  final TextEditingController _pinController = TextEditingController();
  final secureStorage = FlutterSecureStorage();
  String? firstPin;
  bool isConfirming = false;

  String hashPin(String pin) {
    final bytes = utf8.encode(pin);
    final digest = sha256.convert(bytes);
    return digest.toString(); 
  }
Future<void> _handlePinCompleted(String value) async {
  if (!isConfirming) {
    setState(() {
      firstPin = value;
      isConfirming = true;
      _pinController.clear();
    });
    return; 
  }
  if (value != firstPin) {
    setState(() {
      firstPin = null;
      isConfirming = false;
      _pinController.clear();
    });
    customErrorShowMeme(context);
    return;
  }
  final walletAuthProvider = Provider.of<WalletAuthProvdiver>(context, listen: false);
  final navigator = Navigator.of(context);
  customLoader(context);
  try {
    final hashedPin = hashPin(firstPin!);
    await secureStorage.write(key: 'user_pin_hash', value: hashedPin);
    print("Hashed PIN stored successfully.");
    await walletAuthProvider.registerUserOnBackend(Network.Testnet);
    print("User registered on backend successfully.");
    await navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
      (Route<dynamic> route) => false,
    );
  } catch (e) {
    print("An error occurred during final setup: $e");
    customNetworkErrorDialog(context);
    setState(() {
        firstPin = null;         // Go back to the "Set Your PIN" stage
        isConfirming = false;
        _pinController.clear();  // This clears the text field as you wanted
    });
  }
}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kwhitecolor,
      appBar: AppBar(backgroundColor: kwhitecolor, elevation: 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 90),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Positioned(
                      child: customcontainer(
                        200,
                        size.width / 1.2,
                        const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/vector2.png'),
                          ),
                        ),
                        const SizedBox(),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      left: 4,
                      child: customcontainer(
                        200,
                        size.width / 1.2,
                        const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/meme5.png'),
                          ),
                        ),
                        const SizedBox(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 25),
            Text(
              isConfirming ? 'Confirm Your PIN' : 'Set Your Bag, Set A Code',
              style: vtitletextstyle,
            ),
            Text(
              isConfirming
                  ? 'Enter the same 6-digit code to confirm'
                  : 'Just 6 digits between you and total wallet chaos',
              style: vsubtitletextstyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 35),
            SizedBox(
              width: size.width / 1.4,
              child: PinCodeTextField(
                appContext: context,
                length: 6,
                controller: _pinController,
                obscureText: false,
                animationType: AnimationType.slide,
                animationDuration: const Duration(milliseconds: 300),
                backgroundColor: Colors.white,
                enableActiveFill: true,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9]'),
                  ), // Only digits allowed
                ],
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeFillColor: kbackupcolor,
                  selectedFillColor: kbackupcolor,
                  errorBorderColor: kbackupcolor,
                  inactiveFillColor: kbackupcolor,
                ),
                onCompleted: _handlePinCompleted,
              ),
            ),
            const SizedBox(height: 195),
          ],
        ),
      ),
    );
  }
}
