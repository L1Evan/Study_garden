import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'seed_shop_screen.dart';
import 'study_log_screen.dart';
import 'settings_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  // Tracks which tab is selected
  int _currentIndex = 0;

  // List of screens - order matches bottom nav items
  final List<Widget> _screens = [
    const Homescreen(),      // Index 0
    const SeedShop(),        // Index 1  
    const StudyLog(),        // Index 2
    const SettingScreen(),   // Index 3
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack keeps all screens alive in memory
      // This preserves scroll position and state when switching tabs
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      
      bottomNavigationBar: NavigationBar(
        // Material 3 NavigationBar (modern bottom nav)
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.local_florist_outlined),
            selectedIcon: Icon(Icons.local_florist),
            label: 'Garden',
          ),
          NavigationDestination(
            icon: Icon(Icons.store_outlined),
            selectedIcon: Icon(Icons.store),
            label: 'Shop',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Log',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}