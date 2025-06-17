import 'package:flutter/foundation.dart';

class Walletmodel {
  final String seedphrase;
  final String address;
  final double balances;

  Walletmodel({
    required this.seedphrase,
    required this.address,
    required this.balances,
  });

  factory Walletmodel.fromJson(Map<String, dynamic> json) {
    return Walletmodel(
      address: json['address'],
      balances: json['balances'].toDouble(),
      seedphrase: json['seedPhrase'],
    );
  }
}
