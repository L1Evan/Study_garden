import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/garden_provider.dart';
import 'main_shell.dart';

class StudySproutApp extends StatelessWidget {
  const StudySproutApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider makes GardenProvider available to entire app
    return ChangeNotifierProvider(
      create: (context) => GardenProvider()..initialize(),
      // ..initialize() = cascade notation = create THEN call initialize()
      
      child: MaterialApp(
        title: 'StudySprout',
        debugShowCheckedModeBanner: false,
        
        // ThemeData defines the design language
        theme: ThemeData(
          // Material 3 = modern Android design (rounded corners, dynamic colors)
          useMaterial3: true,
          
          // ColorScheme generates harmonious palette from one seed color
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4CAF50), // Sage green
            brightness: Brightness.light,
          ),
          
          // Global card styling (applies to ALL cards in app)
          cardTheme: CardTheme(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          
          // Global app bar styling
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
        ),
        
        // The home screen is our navigation shell
        home: const MainShell(),
      ),
    );
  }
}import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/garden_provider.dart';
import 'main_shell.dart';

class StudyGardenApp extends StatelessWidget {
  const StudyGardenApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider makes GardenProvider available to entire app
    return ChangeNotifierProvider(
      create: (context) => GardenProvider()..initialize(),
      // ..initialize() = cascade notation = create THEN call initialize()
      
      child: MaterialApp(
        title: 'StudySprout',
        debugShowCheckedModeBanner: false,
        
        // ThemeData defines the design language
        theme: ThemeData(
          // Material 3 = modern Android design (rounded corners, dynamic colors)
          useMaterial3: true,
          
          // ColorScheme generates harmonious palette from one seed color
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4CAF50), // Sage green
            brightness: Brightness.light,
          ),
          
          // Global card styling (applies to ALL cards in app)
          cardTheme: CardTheme(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          
          // Global app bar styling
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
        ),
        
        // The home screen is our navigation shell
        home: const MainShell(),
      ),
    );
  }
}