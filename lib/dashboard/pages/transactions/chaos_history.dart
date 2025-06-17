import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'chaos_item.dart'; // Adjust this import path to where chaosItem is defined

enum FilterOption { In, Out, Date, Amount }

class Transaction {
  final bool isIn;
  final String date;
  final String from;
  final double amount;

  Transaction({
    required this.isIn,
    required this.date,
    required this.from,
    required this.amount,
  });
}

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  FilterOption _selectedFilter = FilterOption.In;

  List<Transaction> allTransactions = [
    Transaction(isIn: false, date: 'Today', from: 'Rate162', amount: 0.001),
    Transaction(isIn: true, date: 'Today', from: 'Rate162', amount: 0.002),
    Transaction(isIn: false, date: 'Today', from: 'Rate162', amount: 0.0005),
    Transaction(isIn: true, date: 'Yesterday', from: 'Rate162', amount: 0.01),
    Transaction(isIn: true, date: 'Yesterday', from: 'Rate162', amount: 0.0001),
  ];

  List<Transaction> get filteredTransactions {
    switch (_selectedFilter) {
      case FilterOption.In:
        return allTransactions.where((t) => t.isIn).toList();
      case FilterOption.Out:
        return allTransactions.where((t) => !t.isIn).toList();
      case FilterOption.Date:
        return allTransactions; // No date sorting applied
      case FilterOption.Amount:
        final sorted = List<Transaction>.from(allTransactions);
        sorted.sort((a, b) => b.amount.compareTo(a.amount));
        return sorted;
    }
  }

  void onFilterSelected(FilterOption option) {
    setState(() {
      _selectedFilter = option;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isMobile),
            const Divider(height: 1),
            const SizedBox(height: 12),
            _buildFilterButtons(),
            const SizedBox(height: 16),
            Expanded(child: _buildTransactionList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: isMobile ? 12 : 20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Recent Chaos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 48), // Placeholder for symmetry
        ],
      ),
    );
  }

  Widget _buildFilterButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 10,
        runSpacing: 8,
        children: [
          _buildFilterButton('In', FilterOption.In),
          _buildFilterButton('Out', FilterOption.Out),
          _buildFilterButton('Date', FilterOption.Date),
          _buildFilterButton('Amount', FilterOption.Amount),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label, FilterOption option) {
    final isSelected = _selectedFilter == option;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: isSelected ? 3 : 0,
        // primary: isSelected ? Colors.white : Colors.grey[200],
        // onPrimary: Colors.black87,
        side: isSelected
            ? const BorderSide(color: Colors.black87, width: 1.5)
            : BorderSide(color: Colors.grey.shade400),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      onPressed: () => onFilterSelected(option),
      child: Text(label),
    );
  }

  Widget _buildTransactionList() {
    if (filteredTransactions.isEmpty) {
      return const Center(child: Text('No transactions'));
    }

    return ListView.builder(
      itemCount: filteredTransactions.length,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemBuilder: (context, index) {
        final tx = filteredTransactions[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ChaosItem( // Custom transaction widget
            isIn: tx.isIn,
            date: tx.date,
            from: tx.from,
            amount: tx.amount,
          ),
        );
      },
    );
  }
}

class ChaosItem extends StatelessWidget {
  final bool isIn;
  final String date;
  final String from;
  final double amount;

  const ChaosItem({
    super.key,
    required this.isIn,
    required this.date,
    required this.from,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isIn ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isIn ? Colors.green.shade200 : Colors.red.shade200,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Side: From + Date
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isIn ? 'Received from' : 'Sent to',
                style: GoogleFonts.quicksand(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                from,
                style: GoogleFonts.quicksand(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: GoogleFonts.quicksand(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          // Right Side: Amount
          Text(
            '${isIn ? '+' : '-'}${amount.toStringAsFixed(4)} BTC',
            style: GoogleFonts.quicksand(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isIn ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
