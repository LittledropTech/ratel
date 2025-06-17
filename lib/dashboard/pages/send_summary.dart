import 'dart:convert';

import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:bitsure/dashboard/pages/sat_sent.dart';
import 'package:bitsure/utils/customutils.dart';
import 'package:bitsure/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../gen/assets.gen.dart';
import 'sats_failed.dart';
import 'transaction_pin_entry.dart';

class SendSummaryScreen extends StatefulWidget {
  final String amountInBTC;
  final String recipientAddress;
  final String memo;
  final Wallet wallet;
  final String networkFee;
  final Network network;

  const SendSummaryScreen({
    super.key,
    required this.amountInBTC,
    required this.recipientAddress,
    required this.memo,
    required this.wallet,
    required this.networkFee,
    required this.network,
  });

  @override
  State<SendSummaryScreen> createState() => _SendSummaryScreenState();
}

class _SendSummaryScreenState extends State<SendSummaryScreen> {
  String txId = '';
  
  Future<double> fetchRecommendedFeeRate() async {
    try {
      final response = await http.get(
        Uri.parse('https://mempool.space/api/v1/fees/recommended'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['halfHourFee'].toDouble(); // e.g., 12.5
      } else {
        throw Exception("Failed to fetch fee rate");
      }
    } catch (e) {
      // Return a fallback default if API fails
      return 10.0;
    }
  }

  Future<String> sendBitcoin({
    required BuildContext context,
    required Wallet wallet,
    required String recipientAddress,
    required int amountInSats,
    double? feeRate, // Optional override
  }) async {
    try {
      // Create the recipient address object
      final address = await Address.create(address: recipientAddress);

      // Create the transaction builder
      final txBuilder = TxBuilder();

      // Add recipient and amount
      final script = await address.scriptPubKey();
      txBuilder.addRecipient(script, amountInSats);

      // Fetch or use provided fee rate
      final dynamicFeeRate = feeRate ?? await fetchRecommendedFeeRate();
      txBuilder.feeRate(dynamicFeeRate);

      // Build the transaction
      final txBuilderResult = await txBuilder.finish(wallet);
      final psbt = txBuilderResult.psbt;

      // Sign the transaction
      final signedPsbt = await wallet.sign(psbt: psbt);

      // Extract the signed transaction
      final signedTx = await signedPsbt.extractTx();

      // Get transaction ID before broadcasting
      final txid = await signedTx.txid();

      // Create blockchain connection for broadcasting
      final blockchain = await Blockchain.create(
        config: BlockchainConfig.electrum(
          config: ElectrumConfig(
            url: widget.network == Network.Testnet
                ? 'ssl://electrum.blockstream.info:60004'
                : 'ssl://electrum.blockstream.info:60002',
            socks5: null,
            retry: 5,
            timeout: 10,
            stopGap: 10,
            validateDomain: false,
          ),
        ),
      );

      // Broadcast the transaction
      await blockchain.broadcast(signedTx);

      // Notify success
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Transaction sent!\nTXID: $txid")));
      setState(() {
        txId = txid;
      });
      return txid;
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
      throw Exception('Failed to send Bitcoin: $e');
    }
  }

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
        title: Text("Summary", style: titleStyle.copyWith(fontSize: 24)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 80),
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(Assets.images.greenFlag.path),
            ),
            const SizedBox(height: 12),
            const Text(
              'Final Look Before the Yeet',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 48),
            SummaryTile(
              title: 'Amount',
              value: '${widget.amountInBTC} BTC (~\$${widget.amountInBTC})',
            ),
            const SizedBox(height: 16),
            SummaryTile(title: 'To', value: widget.recipientAddress),
            const SizedBox(height: 16),
            SummaryTile(title: 'Memo', value: widget.memo),
            const SizedBox(height: 16),
            SummaryTile(
              title: 'Network Fee',
              value:
                  '${(num.parse(widget.networkFee) / 100000000).toStringAsFixed(8)} Sats (Fast AF)',
            ),
            const Spacer(),
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
                onPressed: () async {
                  createTransaction(
                    BuildContext context, {
                    required String transactionPin,
                  }) async {
                    sendBitcoin(
                      context: context,
                      wallet: widget.wallet,
                      recipientAddress: widget.recipientAddress,
                      amountInSats: btcToSats(double.parse(widget.amountInBTC)),
                    );
                  }

                  final bool worked = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PinEntryScreen(funcCall: createTransaction),
                    ),
                  );

                  if (worked) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => DraggableScrollableSheet(
                        initialChildSize: 0.85,
                        minChildSize: 0.5,
                        maxChildSize: 0.95,
                        expand: false,
                        builder: (_, controller) => Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(32),
                            ),
                          ),
                          child: SingleChildScrollView(
                            controller: controller,
                            child: SatsSentBottomSheet(
                              time: DateTime.now(),
                              amount: double.parse(widget.amountInBTC),
                              address: widget.recipientAddress,
                              fee: double.parse(
                                (num.parse(widget.networkFee) / 100000000)
                                    .toStringAsFixed(8),
                              ),
                              status: 'Completed',
                              network: widget.network == Network.Testnet
                                  ? 'testnet'
                                  : 'mainnet',
                              txid: txId,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => DraggableScrollableSheet(
                        initialChildSize: 0.85,
                        minChildSize: 0.4,
                        maxChildSize: 0.95,
                        expand: false,
                        builder: (_, controller) => Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(32),
                            ),
                          ),
                          child: SingleChildScrollView(
                            controller: controller,
                            child: SatsFailedBottomSheet(),
                          ),
                        ),
                      ),
                    );
                  }
                  //  Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => PinEntryScreen(),
                  //     ),
                  //   );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: Text(
                  "Enter my PIN",
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class SummaryTile extends StatelessWidget {
  final String title;
  final String value;

  const SummaryTile({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F6),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.black, offset: Offset(2, 3), blurRadius: 2),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
