import 'package:flutter/material.dart' show BuildContext, MaterialApp, StatelessWidget, ThemeMode, Widget, runApp;
import 'package:claycraft_google_gen_ai/theme.dart';
import 'package:claycraft_google_gen_ai/screens/home_screen.dart';

void main() {
  runApp(const ClayCraftApp());
}

class ClayCraftApp extends StatelessWidget {
  const ClayCraftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClayCraft',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
