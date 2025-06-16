import 'package:bitsure/gen/assets.gen.dart';
import 'package:bitsure/utils/customutils.dart';
import 'package:bitsure/utils/theme.dart';
import 'package:flutter/material.dart';

class SatsSentBottomSheet extends StatelessWidget {
  const SatsSentBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.close, size: 24)),
              Text(
                "Sats Sent, Vibes Delivered",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 24), // to balance the close icon space
            ],
          ),
          const SizedBox(height: 24),

          // Star flower with circular image in the center
           Stack(
              children: [
                Positioned(
                  child: customcontainer(
                    200,
                    MediaQuery.sizeOf(context).width / 1.3,
                    BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(Assets.images.successStar.path),
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
                        image: AssetImage(Assets.images.onPoint.path),
                      ),
                    ),
                    const SizedBox(),
                  ),
                ),
              ],
            ),

          const SizedBox(height: 24),
          const Text(
            "You Did it. Sats in Motion",
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Info rows
          _infoRow("Amount Sent", "0.0007 BTC (\$22.80)"),
          _infoRow("To", "@CatFoodDAO"),
          _infoRow("Network Fee", "0.0001 BTC"),
          _infoRow("Status", "Confirmed"),
          _infoRow("Time", "Today, 2:47 PM"),
          const SizedBox(height: 32),

          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6F7EFF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      elevation: 4,
                    ),
                    onPressed: () {},
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'Back to bag',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow:  [
                          BoxShadow(
                            color: klightbluecolor,
                            offset: Offset(3, 4),
                            blurRadius: 2,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      elevation: 4,
                    ),
                    onPressed: () {},
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text('Receipt?'),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black54),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
