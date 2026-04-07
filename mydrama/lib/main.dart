import 'package:flutter/material.dart';

import 'data/dummy_dramas.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyDramaApp());
}

class MyDramaApp extends StatefulWidget {
  const MyDramaApp({super.key});

  @override
  State<MyDramaApp> createState() => _MyDramaAppState();
}

class _MyDramaAppState extends State<MyDramaApp> {
  bool isAdmin = false;
  bool isLoggedIn = false;

  void _handleLogin(bool adminMode) {
    setState(() {
      isAdmin = adminMode;
      isLoggedIn = true;
    });
  }

  void _logout() {
    setState(() {
      isLoggedIn = false;
      isAdmin = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyDrama',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF052B3F),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF10B8D5)),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Arial'),
        ),
      ),
      home: isLoggedIn
          ? HomeScreen(
              isAdmin: isAdmin,
              initialData: initialDramas(),
              onLogout: _logout,
            )
          : LoginScreen(onLogin: _handleLogin),
    );
  }
}
