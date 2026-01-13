import 'package:flutter/material.dart';
import 'constants/app_themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce App',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.system, // Auto-switch based on system
      home: Scaffold(
        appBar: AppBar(
          title: Text('Theme Test'),
        ),
        body: Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Themes are working!'),
            ),
          ),
        ),
      ),
    );
  }
}