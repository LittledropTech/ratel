import 'dart:convert';

import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:bitsure/dashboard/pages/dashboard.dart';
import 'package:bitsure/provider/wallet_authprovider.dart';
import 'package:bitsure/dashboard/pages/dashboard.dart';
import 'package:bitsure/utils/customutils.dart';
import 'package:bitsure/utils/textstyle.dart';
import 'package:bitsure/utils/theme.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class RestoreNewCode extends StatefulWidget {
 
 const RestoreNewCode({super.key});

  @override
  State<RestoreNewCode> createState() => _RestoreNewCodeState();
}

class _RestoreNewCodeState extends State<RestoreNewCode> {
  final TextEditingController _pinController = TextEditingController();
  final secureStorage = FlutterSecureStorage();

  String? firstPin;
  bool isConfirming = false;

  String hashPin(String pin) {
    final bytes = utf8.encode(pin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  void _handlePinCompleted(String value) async {
    if (!isConfirming) {
      // First PIN entry
      setState(() {
        firstPin = value;
        isConfirming = true;
        _pinController.clear();
      });
    } else {
      // Confirm PIN
      if (value == firstPin) {
        final hashedPin = hashPin(firstPin!);
        print("storeHashed :$hashedPin");
        await secureStorage.write(key: 'user_pin_hash', value: hashedPin);
          Navigator.push(context,MaterialPageRoute(builder: (context){
            return  DashboardScreen();
          }));
        customSnackBar('Pin set successfully', klightbluecolor, context);
      } else {
        setState(() {
          firstPin = null;
          isConfirming = false;
          _pinController.clear();
        });
        
      }
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