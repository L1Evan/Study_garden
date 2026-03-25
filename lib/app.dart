import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/garden_provider.dart';
import 'screens/main_shell.dart';

class StudySproutApp extends StatelessWidget {
  const StudySproutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GardenProvider()..initialize(),
      child: MaterialApp(
        title: 'StudySprout',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4CAF50),
            brightness: Brightness.light,
          ),
          cardTheme: CardThemeData(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
        ),
        home: MainShell(),  // ← REMOVED 'const' - add back if MainShell has const constructor
      ),
    );
  }
}