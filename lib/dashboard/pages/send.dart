import 'dart:convert';
import 'dart:developer';

import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:bitsure/dashboard/pages/scan_qr.dart';
import 'package:bitsure/dashboard/pages/send_summary.dart';
import 'package:bitsure/utils/customutils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../gen/assets.gen.dart';
import '../../utils/theme.dart'; // Adjust path based on your structure

class SendBitcoinScreen extends StatefulWidget {
  const SendBitcoinScreen({super.key});

  @override
  State<SendBitcoinScreen> createState() => _SendBitcoinScreenState();
}

class _SendBitcoinScreenState extends State<SendBitcoinScreen> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController memoController = TextEditingController();
  Wallet? _wallet;
  int? _balanceSats;
  bool _isLoading = true;
  String? displayText;
  String? address;
  String? balance;

  void _fillAmount(String amount) {
    setState(() {
      amountController.text = amount;
    });
  }

      Future<double> fetchRecommendedFeeRate() async {
  try {
    final response = await http.get(
      Uri.parse('https://mempool.space/api/v1/fees/recommended'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Use halfHourFee or fastestFee as per your preference
      return data['halfHourFee'].toDouble(); // e.g., 12.5
    } else {
      throw Exception("Failed to fetch fee rate");
    }
  } catch (e) {
    // Return a fallback default if API fails
    return 10.0;
  }
}

  void _sendBitcoin()async {
    final address = addressController.text.trim();
    final amount = amountController.text.trim();
    if (address.isEmpty || amount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Address and Amount are required")),
      );
      return;
    }



  // String  txId = await  sendBitcoin(
  //     amountInSats: btcToSats(double.parse(amount)),
  //     recipientAddress: address,
  //     wallet: _wallet!,
  //     feeRate: 1.5,
  //   );

    // if(txId.isNotEmpty){

    double feeRate = await fetchRecommendedFeeRate();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SendSummaryScreen(
        memo:memoController.text,
        recipientAddress:  address,
        amountInBTC: amount,
        networkFee: feeRate.toString(),
        wallet: _wallet!,
      
      )),
    );
    // } else{
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text("Failed to send Bitcoin")),
    //     );
    // }

 
  }

  @override
  void initState() {
    super.initState();
    _initializeWalletAndBalance();
  }

    Future<void> syncWallet(Wallet wallet, {String? electrumUrl}) async {
  // Default Electrum server for testnet
  final defaultElectrumUrl = electrumUrl ?? 'ssl://electrum.blockstream.info:60002';
  
  final blockchain = await Blockchain.create(
    config: BlockchainConfig.electrum(
      config: ElectrumConfig(
        url: defaultElectrumUrl,
        socks5: null,
        retry: 5,
        timeout: 5,
        stopGap: 10,
        validateDomain: false,
      ),
    ),
  );
  
  await wallet.sync(blockchain);
}

  Future<void> _initializeWalletAndBalance() async {
    try {
      // This assumes you already created descriptors
      final network = Network.Testnet;
      FlutterSecureStorage storage = const FlutterSecureStorage();
      String? mnemonicStr = await storage.read(key: 'users_mnemonics') ?? "";

      final mnemonic = await Mnemonic.fromString(mnemonicStr);

      final descriptorSecretKey = await DescriptorSecretKey.create(
        network: network,
        mnemonic: mnemonic,
      );

      final externalDescriptor = await Descriptor.newBip44(
        secretKey: descriptorSecretKey,
        network: network,
        keychain: KeychainKind.External,
      );

      final internalDescriptor = await Descriptor.newBip44(
        secretKey: descriptorSecretKey,
        network: network,
        keychain: KeychainKind.Internal,
      );

      _wallet = await Wallet.create(
        descriptor: externalDescriptor,
        changeDescriptor: internalDescriptor,
        network: Network.Testnet,
        databaseConfig: const DatabaseConfig.memory(),
      );


    await syncWallet(_wallet!);
      final balance = await _wallet!.getBalance();
      setState(() {
        _balanceSats = balance.total;
        _isLoading = false;
      });

      log(_balanceSats.toString(), name: "Sats Balance");
    } catch (e) {
      debugPrint('Error initializing wallet: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }


 

//   Future<String> sendBitcoinWithFeeEstimation({
//   required Wallet wallet,
//   required String recipientAddress,
//   required double amountInBtc, 
//   required String priority, // "low", "medium", "high"
// }) async {
//   try {
//     // Create blockchain connection for fee estimation
//     final blockchain = await Blockchain.create(
//       config: BlockchainConfig.electrum(
//         config: ElectrumConfig(
//           url: 'ssl://electrum.blockstream.info:60002',
//           socks5: null,
//           retry: 5,
//           timeout: 10,
//           stopGap: 10,
//           validateDomain: false,
//         ),
//       ),
//     );
    
//     // Estimate fee based on priority
//     int confirmationTarget;
//     switch (priority.toLowerCase()) {
//       case 'high':
//         confirmationTarget = 1; // Next block
//         break;
//       case 'medium':
//         confirmationTarget = 6; // ~1 hour
//         break;
//       case 'low':
//         confirmationTarget = 144; // ~24 hours
//         break;
//       default:
//         confirmationTarget = 6;
//     }
    
//     final feeRate = await blockchain.estimateFee(confirmationTarget);
    
//     return await sendBitcoin(
//       wallet: wallet,
//       recipientAddress: recipientAddress,
//       amountInSats: btcToSats(amountInBtc), 
//       feeRate: feeRate.hashCode.toDouble(),
//     );
    
//   } catch (e) {
//     throw Exception('Failed to send Bitcoin with fee estimation: $e');
//   }
// }

  @override
  Widget build(BuildContext context) {
    final titleStyle = GoogleFonts.quicksand(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.black87,
    );
    return Scaffold(
      backgroundColor: kwhitecolor,

      appBar: AppBar(
        backgroundColor: kwhitecolor,
        elevation: 0,
        title: Text(
          "Send your Bitcoin",
          style: titleStyle.copyWith(fontSize: 24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.zero,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _isLoading
                        ? CircularProgressIndicator()
                        : Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    '₿',
                                    style: TextStyle(
                                      fontSize: 56,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  // const SizedBox(width: 1),
                                  Text(
                                    (_balanceSats! / 100000000).toStringAsFixed(
                                      5,
                                    ), // Conve
                                    style: GoogleFonts.quicksand(
                                      fontSize: 48,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Don’t overdo it bestie',
                                    style: GoogleFonts.quicksand(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                    SizedBox(width: 10),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(Assets.images.greenFlag.path),
                        ),
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(1, 2),
                            blurRadius: 1,
                            spreadRadius: 1,
                            blurStyle: BlurStyle.solid,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // const SizedBox(height: 12),

              // Converted amount with emoji image on right
              const SizedBox(height: 42),
              Text(
                "Recipient Bitcoin Address",
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  hintText: "Paste or enter BTC address",
                  border: OutlineInputBorder(),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        child: Assets.icons.qlementineIconsPaste16.svg(),
                        onTap: () async {
                          final clipboardData = await Clipboard.getData(
                            'text/plain',
                          );
                          addressController.text = clipboardData?.text ?? '';
                        },
                      ),
                      SizedBox(width: 10),

                      InkWell(
                        child: Assets.icons.mingcuteScanLine.svg(),
                        onTap: () async {
                          final scannedUsername = await Navigator.push<String>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const QrScannerScreen(),
                            ),
                          );

                          if (scannedUsername != null &&
                              scannedUsername.isNotEmpty) {
                            final cleanUsername =
                                scannedUsername.startsWith('@')
                                ? scannedUsername
                                : '@$scannedUsername';

                            setState(() {
                              addressController.text = cleanUsername;
                            });
                          }
                        },
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Enter Amount (BTC)",
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  hintText: "0.00",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AmountButton(amount: "0.001", onTap: _fillAmount),
                    AmountButton(amount: "0.005", onTap: _fillAmount),
                    AmountButton(amount: "0.01", onTap: _fillAmount),
                    AmountButton(amount: "0.05", onTap: _fillAmount),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Text(
                "Memo (Optional btw)",
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: memoController,
                keyboardType: TextInputType.text,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: "Add a message bestie...",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 32),
              Center(
                child: Text(
                  'Network Fee - \$0.50 (Bitcoin network is expensive rn bestie)',
                  style: GoogleFonts.quicksand(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 32),
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
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _sendBitcoin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: Text(
                    "Send that Satsauce",
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
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
