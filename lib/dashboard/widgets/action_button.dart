import 'package:bitsure/dashboard/pages/learn.dart';
import 'package:bitsure/dashboard/pages/receive.dart';
import 'package:bitsure/dashboard/pages/send.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../gen/assets.gen.dart';
import '../pages/stats.dart';

class ActionButtons extends StatelessWidget {
  final List<ActionButtonData> buttons = [
    ActionButtonData(iconPath: Assets.icons.send.path, label: 'Send'),
    ActionButtonData(iconPath: Assets.icons.receive.path, label: 'Receive'),
    ActionButtonData(
      iconPath: Assets.icons.fluentLearningApp16Regular.path,
      label: 'Learn',
    ),
    ActionButtonData(iconPath: Assets.icons.uilStatistics.path, label: 'Stats'),
  ];

  ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(64),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 24,
          children: buttons
              .map(
                (btn) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        // TODO: implement button tap
                        if (btn.label.toLowerCase() == "learn") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LearnScreen(),
                            ),
                          );
                        }

                        if (btn.label.toLowerCase() == "stats") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StatsScreen(),
                            ),
                          );
                        }

                        if (btn.label.toLowerCase() == "receive") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReceiveBitcoinScreen(),
                            ),
                          );
                        }

                        if (btn.label.toLowerCase() == "send") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SendBitcoinScreen(),
                            ),
                          );
                        }
                      },
                      child: Container(
                        // width: 64,
                        // height: 64,
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade200,
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(3, 4),
                              blurRadius: 2,
                              spreadRadius: 2,
                              blurStyle: BlurStyle.solid,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SvgPicture.asset(
                            btn.iconPath,
                            width: 24,
                            height: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      btn.label,
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class ActionButtonData {
  final String iconPath;
  final String label;
  const ActionButtonData({required this.iconPath, required this.label});
}

// Recent chaos header row
class RecentChaosHeader extends StatelessWidget {
  const RecentChaosHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Recent chaos',
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        TextButton(
          onPressed: () {
            // See all tapped
          },
          child: Text(
            'See all',
            style: GoogleFonts.quicksand(
              color: Colors.blueAccent,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
