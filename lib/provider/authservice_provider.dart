// In a new file, e.g., 'providers/auth_service.dart'
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum AuthState {
  unknown,          //
  unauthenticated,  
  locked,         
  authenticated,   
}
class AuthService with ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  
  // A StreamController to manage our AuthState stream
  final _authStateController = StreamController<AuthState>.broadcast();

  Stream<AuthState?> get authStateStream => _authStateController.stream;

  AuthService() {
    _checkInitialState();
  }
  Future<void> _checkInitialState() async {
    // Checking securestorage to see if a wallet seed phrase exists
    final seed = await _storage.read(key: 'user_pin_hash');
    if (seed != null) {
      _authStateController.add(AuthState.locked);
    } else {
      _authStateController.add(AuthState.unauthenticated);
    }
  }

  // Call this function after the user successfully creates/restores a wallet
  Future<void> completeFirstLogin(List<String> seedPhrase, String pin) async {
    await _storage.write(key: 'user_pin_hash', value: seedPhrase.join(','));
    _authStateController.add(AuthState.authenticated);
  }
  Future<void> unlockApp(String enteredPin) async {
    _authStateController.add(AuthState.authenticated);
  }
  // Call this when the user logs out
  Future<void> logout() async {
    await _storage.deleteAll();
    _authStateController.add(AuthState.unauthenticated);
  }

  @override
  void dispose() {
    _authStateController.close();
    super.dispose();
  }
}