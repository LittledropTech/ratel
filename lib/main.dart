import 'dart:io';
import 'package:bitsure/dashboard/dashboard.dart';
import 'package:bitsure/onboarding/subscreens/pinscreen.dart';
import 'package:bitsure/provider/authservice_provider.dart';
import 'package:bitsure/provider/wallet_authprovider.dart';
import 'package:bitsure/provider/backup_logic_provider.dart';
import 'package:bitsure/provider/introprovider.dart';
import '../onboarding/screens/introscreen.dart';
import '../onboarding/screens/splashscreen.dart';
import 'package:bitsure/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
      create: (_) => Loadingprovider(),
    ),
     ChangeNotifierProvider(
      create: (_) => BackupProvider(),
    ),
     ChangeNotifierProvider(
      create: (_) => WalletAuthProvdiver(),
    ),
      ChangeNotifierProvider(
      create: (_) => AuthService(),
    ),
    ],child: MyApp(),)
  );
  //Disable screenshot on this app
 
  
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: klightbluecolor),
      ),
      home: Consumer<Loadingprovider>(
        builder: (context, loadprovider, _) {
          return loadprovider.isloading?Splashscreen():AuthPage();
        },
      ),
    );
  }
}
 class AuthPage extends StatefulWidget {
  const AuthPage({super.key});
  @override
  State<AuthPage> createState() => _AuthPageState();
}
class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
   final authService = Provider.of<AuthService>(context, listen: false);
    return StreamBuilder<AuthState?>(
      stream: authService.authStateStream,
      builder: (context, snapshot) {
        final authsnapshot = snapshot.data;
        switch (authsnapshot) {
          case AuthState.authenticated:
            return DashboardScreen();
          case AuthState.locked:
          return  PinScreen();

          case AuthState.unauthenticated:
          return Introscreen();
          default:return Splashscreen();
        }
      


    });
  }
}