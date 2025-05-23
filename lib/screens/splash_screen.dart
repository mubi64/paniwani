import 'package:flutter/material.dart';
import 'package:paniwani/screens/navigation_bar_screen.dart';
import 'package:paniwani/screens/welcome_screen.dart';

import '../api/services/auth_service.dart';
import '../models/user.dart';
import 'rider_screens/map_home_screen.dart';
import 'rider_screens/rider_navigation_bar_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    User? user = await authService.getUserInfo(context);

    if (user != null && user.isProfileComplete) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (_) =>
                  user.waterDeliveryBoy == true
                      ? MapHomeScreen()
                      : NavigationBarScreen(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Icon(
          Icons.water_damage_rounded,
          color: Theme.of(context).colorScheme.primary,
          size: 100,
        ),
      ),
    );
  }
}
