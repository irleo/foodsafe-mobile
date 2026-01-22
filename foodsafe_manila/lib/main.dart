import 'package:flutter/material.dart';
import 'mobileShell.dart';
import 'pages/mobileLoginScreen.dart';
import 'pages/mobileRegisterScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        "/login": (_) => const MobileLoginScreen(),
        "/register" : (_) => const MobileRegisterScreen(),
        "/": (_) => const MobileShell(),
      },
       
    );
  }
}
