import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum AuthState { unknown, unauthenticated, locked, authenticated }

class Authservice  extends  ChangeNotifier {
  final storage = FlutterSecureStorage();
  AuthState _authState = AuthState.unknown;
  AuthState get authState => _authState;
      
   Authservice () {
    loadInitialState();
  }
  Future<void> loadInitialState() async {
    print(' ✅  Read my user pin');
    final pinHash = await storage.read(key: 'user_pin_hash');
    print('🔍 Stored PIN hash: $pinHash');
     log('${pinHash}');
    _authState = (pinHash != null)
        ? AuthState.locked
        : AuthState.unauthenticated;

        log('${_authState}}');
    notifyListeners();
  }

  Future<void> unLockapp(String hashedPin) async {
    final hashpin = await storage.read(key: 'user_pin_hash');
    final enterHash = _hashPin(hashedPin);
    if(hashpin == enterHash){
      _authState =AuthState.authenticated;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await storage.deleteAll();
    _authState = AuthState.unauthenticated;
    notifyListeners();
  }



 Future<void> savePin(String pin) async {
  final hashedPin = _hashPin(pin);
  await storage.write(key: 'user_pin_hash', value: hashedPin);
  final confirm = await storage.read(key: 'user_pin_hash');
  print('🔐 Hashed PIN stored: $confirm');
  _authState = AuthState.locked; // lock app after setting PIN
  notifyListeners();
}

  String _hashPin(String pin) {
    final bytes = utf8.encode(pin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
