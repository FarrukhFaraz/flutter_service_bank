import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:service_bank/splash_screen.dart';

import 'Screens/betpro_wallet_screen.dart';
import 'Screens/under_verification.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      title: 'BetPro',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
