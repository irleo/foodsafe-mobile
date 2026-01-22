import 'package:flutter/material.dart';
import 'pages/mobileHomeScreen.dart';
import 'pages/mobileAnalyticsScreen.dart';
import 'pages/mobilePredictionScreen.dart';
import 'pages/mobileAlertsScreen.dart';
// import 'pages/mobileProfileScreen.dart';

class MobileShell extends StatefulWidget {
  const MobileShell({super.key});

  @override
  State<MobileShell> createState() => _MobileShellState();
}

class _MobileShellState extends State<MobileShell> {
  int index = 0;

  final pages = const [
    MobileHomeScreen(),
    MobileAnalyticsScreen(),
    MobilePredictionsScreen(),
    MobileAlertsScreen(),
    // MobileProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Analytics",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: "Predict",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Alerts"),
          // BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
