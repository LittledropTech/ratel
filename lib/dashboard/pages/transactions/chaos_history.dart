// import 'package:flutter/material.dart';



// enum FilterOption { In, Out, Date, Amount }

// class Transaction {
//   final bool isIn;
//   final String date; // Simplified for demo; normally DateTime
//   final String from;
//   final double amount;

//   Transaction({
//     required this.isIn,
//     required this.date,
//     required this.from,
//     required this.amount,
//   });
// }

// class TransactionHistoryPage extends StatefulWidget {
//   @override
//   _TransactionHistoryPageState createState() =>
//       _TransactionHistoryPageState();
// }

// class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
//   FilterOption _selectedFilter = FilterOption.In;

//   // Sample transactions data
//   List<Transaction> allTransactions = [
//     Transaction(isIn: false, date: 'Today', from: 'Rate162', amount: 0.001),
//     Transaction(isIn: true, date: 'Today', from: 'Rate162', amount: 0.001),
//     Transaction(isIn: true, date: 'Today', from: 'Rate162', amount: 0.001),
//     Transaction(isIn: false, date: 'Today', from: 'Rate162', amount: 0.001),
//     Transaction(isIn: true, date: 'Today', from: 'Rate162', amount: 0.001),
//     Transaction(isIn: false, date: 'Today', from: 'Rate162', amount: 0.001),
//     Transaction(isIn: true, date: 'Today', from: 'Rate162', amount: 0.001),
//   ];

//   List<Transaction> get filteredTransactions {
//     switch (_selectedFilter) {
//       case FilterOption.In:
//         return allTransactions.where((t) => t.isIn).toList();
//       case FilterOption.Out:
//         return allTransactions.where((t) => !t.isIn).toList();
//       case FilterOption.Date:
//         // Already sorted by date in this sample - no change
//         return allTransactions;
//       case FilterOption.Amount:
//         // Sort by amount descending
//         List<Transaction> sorted = List.from(allTransactions);
//         sorted.sort((a, b) => b.amount.compareTo(a.amount));
//         return sorted;
//     }
//   }

//   void onFilterSelected(FilterOption option) {
//     setState(() {
//       _selectedFilter = option;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Responsive breakpoint
//     final screenWidth = MediaQuery.of(context).size.width;
//     bool isMobile = screenWidth < 768;

//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             _buildHeader(context, isMobile),
//             Divider(height: 1),
//             _buildUserInfo(),
//             SizedBox(height: 16),
//             _buildFilterButtons(),
//             SizedBox(height: 16),
//             Expanded(child: _buildTransactionList()),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader(BuildContext context, bool isMobile) {
//     return Container(
//       padding:
//           EdgeInsets.symmetric(horizontal: 16, vertical: isMobile ? 12 : 20),
//       alignment: Alignment.centerLeft,
//       child: Row(
//         children: [
//           IconButton(
//             icon: Icon(Icons.arrow_back_ios_new_outlined,
//                 color: Colors.black87, size: 22),
//             onPressed: () {
//               // For demo, just show SnackBar
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Back button pressed')),
//               );
//             },
//             tooltip: 'Back',
//           ),
//           Expanded(
//             child: Text(
//               'Recent Chaos',
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: isMobile ? 20 : 24,
//                 color: Colors.black87,
//                 letterSpacing: 0.3,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           SizedBox(width: 48), // Space for symmetry with back button
//         ],
//       ),
//     );
//   }

//   Widget _buildUserInfo() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Row(
//         children: [
//           // Avatar circle with placeholder image from placehold.co
//           CircleAvatar(
//             radius: 32,
//             backgroundColor: Colors.grey[200],
//             backgroundImage: NetworkImage(
//               'https://placehold.co/128x128/png?text=Avatar',
//             ),
//             onBackgroundImageError: (_, __) => Container(color: Colors.grey),
//             child: Semantics(
//               label: 'User Avatar',
//               image: true,
//             ),
//           ),
//           SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Your Sats Did What??',
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 17,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   'receipts for the madness',
//                   style: TextStyle(
//                     fontWeight: FontWeight.w400,
//                     fontSize: 14,
//                     color: Colors.grey[700],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFilterButtons() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Wrap(
//         spacing: 12,
//         runSpacing: 8,
//         children: [
//           _buildFilterButton('In', FilterOption.In),
//           _buildFilterButton('Out', FilterOption.Out),
//           _buildFilterButton('Date', FilterOption.Date),
//           _buildFilterButton('Amount', FilterOption.Amount),
//         ],
//       ),
//     );
//   }

//   Widget _buildFilterButton(String label, FilterOption option) {
//     final bool isSelected = _selectedFilter == option;

//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         elevation: isSelected ? 4 : 0,
//         primary: isSelected ? Colors.white : Colors.grey[200],
//         onPrimary: Colors.black87,
//         shadowColor: Colors.black45,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//           side: isSelected
//               ? BorderSide(color: Colors.black87, width: 1.5)
//               : BorderSide(color: Colors.grey.shade400),
//         ),
//         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//         textStyle: TextStyle(
//           fontWeight: FontWeight.w500,
//           fontSize: 14,
//         ),
//       ),
//       onPressed: () => onFilterSelected(option),
//       child: Text(label),
//     );
//   }

//   Widget _buildTransactionList() {
//     if (filteredTransactions.isEmpty) {
//       return Center(
//         child: Text(
//           'No transactions',
//           style: TextStyle(color: Colors.grey[600], fontSize: 16),
//         ),
//       );
//     }

//     return ListView.separated(
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       itemCount: filteredTransactions.length,
//       separatorBuilder: (_, __) => SizedBox(height: 14),
//       itemBuilder: (context, index) {
//         final tx = filteredTransactions[index];
//         return _buildTransactionItem(tx);
//       },
//     );
//   }

//   Widget _buildTransactionItem(Transaction tx) {
//     final icon = tx.isIn ? Icons.arrow_downward : Icons.arrow_upward;
//     final iconColor = tx.isIn ? Colors.green.shade400 : Colors.red.shade400;

//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         CircleAvatar(
//           backgroundColor: iconColor.withOpacity(0.15),
//           radius: 20,
//           child: Icon(icon, color: iconColor, size: 22),
//         ),
//         SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 tx.date,
//                 style: TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16,
//                   color: Colors.black87,
//                 ),
//               ),
//               SizedBox(height: 2),
//               Text(
//                 'from ${tx.from}',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w400,
//                   fontSize: 13,
//                   color: Colors.grey[700],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Text(
//           '+${tx.amount.toStringAsFixed(3)}',
//           style: TextStyle(
//             fontWeight: FontWeight.w500,
//             fontSize: 14,
//             color: Colors.black87,
//           ),
//         ),
//       ],
//     );
//   }
// }