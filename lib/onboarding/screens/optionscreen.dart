import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:bitsure/network/createwallet.dart';
import 'package:bitsure/policy/policiesscreen.dart';
import 'package:bitsure/onboarding/restorewalletflow/restorewalletscreen.dart';
import 'package:bitsure/provider/networkprovider.dart';
import 'package:bitsure/provider/wallet_authprovider.dart';

import 'package:bitsure/utils/customutils.dart'show custombuttons, customcontainer;
import 'package:bitsure/utils/textstyle.dart';
import 'package:bitsure/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Optionscreen extends StatefulWidget {
  const Optionscreen({super.key});

  @override
  State<Optionscreen> createState() => _OptionscreenState();
}

class _OptionscreenState extends State<Optionscreen> {
  
  List<String>? _mnemonic;
  bool _isCreatingWallet = false;
  late final  Network network;

@override
  void initState() {
    network = context.read<NetworkProvider>().network;
    super.initState();
  }
    
  Future<void> _createWallets() async {
    setState(() {
      _isCreatingWallet = true;
    });

    try {
      final walletData = await createWallet(network);

      // Fix: Update class field, not create new local variable
      _mnemonic = walletData['mnemonics'].toString().split(" ");
      print('Wallet created with mnemonic: $_mnemonic');

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Policiesscreen(mnemonics: _mnemonic!);
            },
          ),
        );
      }
    } catch (e) {
      print('Error creating wallet: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create wallet: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreatingWallet = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 150),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Positioned(
                      child: customcontainer(
                        245,
                        245,
                        BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/vector1.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(),
                      ),
                    ),
                    Positioned(
                      left: 60,
                      top: 65,
                      child: customcontainer(
                        140,
                        140,
                        BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/meme3.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'So you want to touch\n some Bitcoins Huh?',
                style: GoogleFonts.quicksand(
                  fontSize: 25,
                  
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 140),

              // Create Wallet Button
              custombuttons(
                40,
                size.width / 1.2,
                BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: kblackcolor,
                      spreadRadius: 0.5,
                      blurRadius: 0.5,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  color: klightbluecolor,
                  borderRadius: BorderRadius.circular(20),
                ),
                _isCreatingWallet
                    ? null
                    : _createWallets, // Disable when loading
                Center(
                  child: _isCreatingWallet
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('Creating...', style: vbuttontextstyles),
                          ],
                        )
                      : Text('Create Wallet', style: vbuttontextstyles),
                ),
              ),
              const SizedBox(height: 14),

              // Restore Wallet Button
              custombuttons(
                40,
                size.width / 1.2,
                BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: kblackcolor,
                      spreadRadius: 0.5,
                      blurRadius: 3,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  color: kblackcolor,
                  borderRadius: BorderRadius.circular(20),
                ),
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Restorewalletscreen();
                      },
                    ),
                  );
                },
                Center(
                  child: Text(
                    'Restore from seed phrase',
                    style: vbuttontextstyles,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
