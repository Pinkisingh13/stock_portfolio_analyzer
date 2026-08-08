import 'package:flutter/material.dart';
import 'package:frontend/providers/home_provider.dart';
import 'package:provider/provider.dart';
import 'view/home_screen.dart';
import 'view/markets_screen.dart';
import 'view/settings_screen.dart';
import 'widgets/bottom_nav_bar.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => HomeProvider(),
      child: const PortfolioAnalyzerApp(),
    ),
  );
}

class PortfolioAnalyzerApp extends StatelessWidget {
  const PortfolioAnalyzerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Portfolio Analyzer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF101126),
        fontFamily: 'Inter',
        colorScheme: const ColorScheme.dark(
          surface: Color(0xFF1D1E33),
          primary: Color(0xFFDEB7FF),
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = const [
    HomeScreen(),
    MarketsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
