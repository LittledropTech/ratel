import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecentChaosList extends StatelessWidget {
  final List<ChaosItem> items;

  const RecentChaosList({
    super.key,
    this.items = const [
      ChaosItem(isUp: true, date: 'Today', from: 'Ratel62', amount: '+0.001'),
      ChaosItem(isUp: false, date: 'Today', from: 'Ratel62', amount: '+0.001'),
      ChaosItem(isUp: false, date: 'Today', from: 'Ratel62', amount: '+0.001'),
    ],
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(), // prevents nested scroll conflict
      itemBuilder: (context, index) {
        final item = items[index];
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
                color: item.isUp ? Colors.red.shade700 : Colors.green.shade700,
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
            'from ${item.from}',
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
    );
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
