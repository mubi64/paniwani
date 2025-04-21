import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const PaniWaniApp());
}

class PaniWaniApp extends StatelessWidget {
  const PaniWaniApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PaniWani',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),
    );
  }
}