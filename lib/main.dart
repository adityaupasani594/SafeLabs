import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:safe_labs/desktop/web_dashboard_screen.dart';
import 'package:safe_labs/mobile/screens/mobile_login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Widget home;
    if (kIsWeb) {
      home = const WebDashboardScreen();
    } else {
      home = const MobileLoginScreen();
    }

    return MaterialApp(
      title: 'SafeLabs',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE6E6FA)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: home,
    );
  }
}
