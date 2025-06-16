import 'package:bitsure/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../gen/assets.gen.dart';
import 'transaction_pin_entry.dart';

class SendSummaryScreen extends StatelessWidget {
  const SendSummaryScreen({super.key});

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
          "Summary",
          style: titleStyle.copyWith(fontSize: 24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 80),
            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(Assets.images.greenFlag.path), // Replace with your image
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
            const SummaryTile(
              title: 'Amount',
              value: '0.002 BTC (~\$142.50)',
            ),
            const SizedBox(height: 16),
            const SummaryTile(
              title: 'To',
              value: '@CatFoodDAO',
            ),
            const SizedBox(height: 16),
            const SummaryTile(
              title: 'Memo',
              value: 'Snack Time',
            ),
            const SizedBox(height: 16),
            const SummaryTile(
              title: 'Network Fee',
              value: '0.0001 BTC (Fast AF)',
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
                  onPressed: (){
                         Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PinEntryScreen(),
                            ),
                          );
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

  const SummaryTile({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F6),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(2, 3),
            blurRadius: 2,
          ),
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
