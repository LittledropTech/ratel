import 'package:bitsure/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../gen/assets.gen.dart';
import '../widgets/action_button.dart';
import '../widgets/recernt_chaos_list.dart';
import '../widgets/wallet_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 768;

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 16 : 50,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row with avatar, greeting and bell icon
                      _buildHeader(context, isMobile),

                      const SizedBox(height: 24),

                      // Wallet Info Card
                      WalletCard(isMobile: isMobile),

                      const SizedBox(height: 32),

                      // Motivational quote text
                      Center(
                        child: Text(
                          '"Up 3% this week. You’re basically Warren Buffet',
                          style: GoogleFonts.quicksand(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Action buttons section
                      ActionButtons(),

                      const SizedBox(height: 8),

                      // Recent chaos header with see all
                    ],
                  ),
                ),

                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 24, left: 24, right: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    child: Column(
                      children: [
                        RecentChaosHeader(),
                        // Recent chaos list
                        RecentChaosList(),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) => Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Semantics(
        label: 'User profile picture',
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          },
          child: CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage(Assets.images.balablu.path),
            backgroundColor: Colors.grey.shade300,
          ),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, Onionsman',
              style: GoogleFonts.quicksand(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 3),
            Text(
              'GM Bestie, make the moves',
              style: GoogleFonts.quicksand(
                fontSize: 13,
                color: Colors.black54,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      IconButton(
        icon: Assets.icons.solarBellLinear.svg(),
        iconSize: 28,
        color: Colors.black87,
        onPressed: () {
          // handle notifications pressed
        },
        tooltip: 'Notifications',
      ),
    ],
  );
}
