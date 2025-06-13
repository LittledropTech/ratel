import 'dart:io';
import 'package:bitsure/provider/backup_logic_provider.dart';
import 'package:bitsure/screens/introprovider.dart';
import 'package:bitsure/screens/introscreen.dart';
import 'package:bitsure/screens/splashscreen.dart';
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
    ],child: MyApp(),)
  );
  //Disable screenshot on this app
  WidgetsBinding.instance.addPostFrameCallback((timeStamp)async{
    if(Platform.isAndroid){
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    }
  });
  
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
          return loadprovider.isloading?Splashscreen():Introscreen();
        },
      ),
    );
  }
}
