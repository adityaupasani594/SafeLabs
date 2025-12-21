import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:safe_labs/mobile/screens/mobile_login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeLabs',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE6E6FA)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: kIsWeb
          ? const Scaffold(body: Center(child: Text("Web Dashboard"))) // Placeholder for Web
          : const MobileLoginScreen(),
    );
  }
}
