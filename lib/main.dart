import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/cart_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  // Simple main without Firebase first
  runApp(const DebugApp());
}

class DebugApp extends StatelessWidget {
  const DebugApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Retail Commerce - Debug',
        theme: ThemeData(
          primarySwatch: Colors.green,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        debugShowCheckedModeBanner: true,
        home: const DebugHomeScreen(),
      ),
    );
  }
}

class DebugHomeScreen extends StatelessWidget {
  const DebugHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug Mode')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 60, color: Colors.green),
            const SizedBox(height: 20),
            const Text(
              'App is Running!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Firebase is temporarily disabled',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Test navigation
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SplashScreen()),
                );
              },
              child: const Text('Test Splash Screen'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Test providers
                final auth = context.read<AuthProvider>();
                final cart = context.read<CartProvider>();
                print('Auth: ${auth.isLoggedIn}');
                print('Cart items: ${cart.itemCount}');
              },
              child: const Text('Test Providers'),
            ),
          ],
        ),
      ),
    );
  }
}