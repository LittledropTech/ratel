import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:bitsure/dashboard/widgets/action_button.dart';
import 'package:bitsure/provider/wallet_authprovider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RecentChaosList extends StatelessWidget {
  final Wallet wallet;

  const RecentChaosList({
    super.key,
    required this.wallet,
  });

  @override
  Widget build(BuildContext context) {
    final walletAuthProvider = Provider.of<WalletAuthProvdiver>(context, listen: false);

    return FutureBuilder<List<TransactionDetails>>(
      future: walletAuthProvider.getTransactionHistory(wallet),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No recent transactions"));
        }

        final chaosItems = convertToChaosItems(snapshot.data!);

        return SingleChildScrollView(
          child: Column(
            children: [
              RecentChaosHeader(),
              ListView.builder(
                itemCount: chaosItems.length,
                shrinkWrap: true,
               
                itemBuilder: (context, index) {
                  final item = chaosItems[index];
                  return ListTile(
                    horizontalTitleGap: 0,
                    contentPadding: EdgeInsets.zero,
                    leading: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey.shade200,
                        child: Icon(
                          item.isUp ? Icons.arrow_upward : Icons.arrow_downward,
                          color: item.isUp ? Colors.green.shade700 : Colors.red.shade700,
                          size: 24,
                        ),
                      ),
                    ),
                    title: Text(
                      item.date,
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      'From ${item.from}',
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    trailing: Text(
                      item.amount,
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  List<ChaosItem> convertToChaosItems(List<TransactionDetails> txList) {
    return txList.map((tx) {
      final isSent = tx.sent > tx.received;
      final amount =
          ((tx.sent - tx.received).abs() / 100000000).toStringAsFixed(8); // Convert sats to BTC

      final date = DateTime.fromMillisecondsSinceEpoch(
        tx.confirmationTime?.timestamp != null
            ? tx.confirmationTime!.timestamp * 1000
            : DateTime.now().millisecondsSinceEpoch,
      );

      return ChaosItem(
        isUp: !isSent,
        date: "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}",
        from: isSent ? "You" : "Someone",
        amount: "${isSent ? '-' : '+'}$amount BTC",
      );
    }).toList();
  }
}

class ChaosItem {
  final bool isUp;       
  final String date;     
  final String from;     
  final String amount;   

  const ChaosItem({
    required this.isUp,
    required this.date,
    required this.from,
    required this.amount,
  });
}

