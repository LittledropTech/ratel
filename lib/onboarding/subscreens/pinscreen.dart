import 'package:bitsure/provider/authservice_provider.dart';
import 'package:bitsure/utils/customutils.dart';
import 'package:bitsure/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

// Import your AuthService and other necessary files

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final TextEditingController _pinController = TextEditingController();
  final _storage = const FlutterSecureStorage();
  final String _errorMessage = '';

  // This is the same hashing function from your Createpinscreen
  String hashPin(String pin) {
    final bytes = utf8.encode(pin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> _handlePinCompleted(String enteredPin) async {
  final authService = Provider.of<AuthService>(context, listen: false);
  final storedHash = await _storage.read(key: 'user_pin_hash');
  final enteredPinHash = hashPin(enteredPin);

  if (enteredPinHash == storedHash) {
    print("PIN correct. Unlocking app.");
    await authService.unlockApp(enteredPin);
  } else {
    customErrorShowMeme(context);
    _pinController.clear();
    
      
  }
}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(backgroundColor: kwhitecolor),
      backgroundColor: kwhitecolor,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 90),
              // You can add your logo or an image here
              Stack(
                children: [

                  Positioned(
                    child: customcontainer(200, size.width/1.3,BoxDecoration(
                      image: DecorationImage(image: AssetImage('assets/vector2.png'))
                    ), SizedBox()),
                  ),
                  Positioned(
                    left: 15,
                    top: 10,
                    child: customcontainer(200, size.width/1.4,BoxDecoration(
                      image: DecorationImage(image: AssetImage('assets/meme5.png'))
                    ), SizedBox()),
                  )
                ],
              ),

              const SizedBox(height: 25),
              const Text(
                'Welcome Back!',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Enter your PIN to unlock your wallet.',
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
                boxShadows: [
                  BoxShadow(
                    color: kgoldencolor
                  )
                ],
                animationType: AnimationType.fade,
                animationDuration: const Duration(milliseconds: 300),
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
            ],
          ),
        ),
      ),
    );
  }
}
