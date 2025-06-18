// lib/provider/network_provider.dart
import 'package:flutter/material.dart';
import 'package:bdk_flutter/bdk_flutter.dart';

class NetworkProvider with ChangeNotifier {
  Network _network = Network.Bitcoin; 
  Network get network => _network;

  void setNetwork(String netEnv) {
    if (netEnv == 'Bitcoin') {
      _network = Network.Bitcoin;
    } else if (netEnv == 'Testnet') {
      _network = Network.Testnet;
    } else {
      throw Exception('Invalid NETWORK value in .env');
    }
    notifyListeners();
  }
}
