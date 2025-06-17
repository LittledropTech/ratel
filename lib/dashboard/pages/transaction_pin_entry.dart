import 'dart:convert';
import 'dart:io';

import 'package:bitsure/dashboard/pages/sat_sent.dart';
import 'package:bitsure/gen/assets.gen.dart';
import 'package:bitsure/provider/authservice_provider.dart';
import 'package:bitsure/utils/customutils.dart';
import 'package:bitsure/utils/theme.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class PinEntryScreen extends StatefulWidget {
    final Function(BuildContext context, {required String transactionPin})?
      funcCall;
  const PinEntryScreen({super.key, required this.funcCall});

  @override
  _PinEntryScreenState createState() => _PinEntryScreenState();
}

class _PinEntryScreenState extends State<PinEntryScreen> {
    final _storage = const FlutterSecureStorage();
  List<String> pin = List.filled(6, '');
  bool obscurePin = true;

  void _onKeyTap(String value) {
    setState(() {
      for (int i = 0; i < pin.length; i++) {
        if (pin[i] == '') {
          pin[i] = value;
          break;
        }
      }
    });
  }

  void _onBackspace() {
    setState(() {
      for (int i = pin.length - 1; i >= 0; i--) {
        if (pin[i] != '') {
          pin[i] = '';
          break;
        }
      }
    });
  }

  Widget _buildPinBox(String value) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.yellow[200],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 0),
        ],
      ),
      child: Text(
        obscurePin && value.isNotEmpty ? '•' : value,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildKey(
    String label, {
    bool isBackspace = false,
    bool isSubmit = false,
  }) {
    return ElevatedButton(
      onPressed: () {
        if (isBackspace) {
          _onBackspace();
        } else if (!isSubmit && label.isNotEmpty) {
          _onKeyTap(label);
        }
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        padding: const EdgeInsets.all(0),
      ),
      child: isBackspace
          ? const Icon(Icons.backspace_outlined)
          : isSubmit
          ? InkWell(
            onTap: ()=>
              _handlePinCompleted(pin.join()),
            child: Container(
                width: 70,
                height: 40,
                decoration: BoxDecoration(
                  color: klightbluecolor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(3, 4),
                      blurRadius: 2,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_forward),
              ),
          )
          : Text(
              label,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child:  Icon( Platform.isIOS? Icons.arrow_back_ios: Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                Positioned(
                  child: customcontainer(
                    200,
                    MediaQuery.sizeOf(context).width / 1.3,
                    BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/vector2.png'),
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
                        image: AssetImage(Assets.images.putin.path),
                      ),
                    ),
                    const SizedBox(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            const Text(
              'Enter your PIN',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter your sacred digits. No pressure.\nJust your entire wallet',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    6,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: _buildPinBox(pin[index]),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => setState(() => obscurePin = !obscurePin),
                  child: Icon(
                    obscurePin ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Flexible(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    shrinkWrap: true,
                    childAspectRatio: 2,
                    children: [
                      ...List.generate(9, (index) => _buildKey('${index + 1}')),
                      _buildKey('', isBackspace: true),
                      _buildKey('0'),
                      _buildKey('', isSubmit: true),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

    String hashPin(String pin) {
    final bytes = utf8.encode(pin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

    Future<void> _handlePinCompleted(String enteredPin) async {
  final authService = Provider.of<Authservice>(context, listen: false);
  final storedHash = await _storage.read(key: 'user_pin_hash');
  final enteredPinHash = hashPin(enteredPin);

  if (enteredPinHash == storedHash) {
    print("PIN correct. Unlocking app.");
    Navigator.pop(context, true);
  } else {
    customErrorShowMeme(context);
    pin.clear();
    
      
  }
}



}
