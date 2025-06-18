import 'package:bitsure/dashboard/pages/dashboard.dart';
import 'package:bitsure/onboarding/subscreens/pinscreen.dart';
import 'package:bitsure/provider/authservice_provider.dart';
import 'package:bitsure/provider/networkprovider.dart';
import 'package:bitsure/provider/wallet_authprovider.dart';
import 'package:bitsure/provider/backup_logic_provider.dart';
import 'package:bitsure/provider/introprovider.dart';
import '../onboarding/screens/introscreen.dart';
import '../onboarding/screens/splashscreen.dart';
import 'package:bitsure/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final networkProvider = NetworkProvider();
  networkProvider.setNetwork('Bitcoin'); 

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Loadingprovider()),
        ChangeNotifierProvider(create: (_) => BackupProvider()),
        ChangeNotifierProvider(create: (_) => WalletAuthProvdiver()),
        ChangeNotifierProvider(create: (_) => Authservice()),
         ChangeNotifierProvider(create: (_) => NetworkProvider()),
      ],
      child: MyApp(),
    ),
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
          return  AuthPage();
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
void initState() {
  super.initState();
  Future.microtask(() {
    Provider.of<Authservice>(context, listen: false).loadInitialState();
  });
}

  @override
  Widget build(BuildContext context) {
    return  Consumer<Authservice>(builder: (context, authservice,child){
        switch (authservice.authState) {
          case AuthState.authenticated:
            return DashboardScreen();
           case AuthState.locked:
           return PinScreen();
           case AuthState.unauthenticated:
           return Introscreen();
           case AuthState.unknown:
          default: return Splashscreen();
        }

    });
}
}