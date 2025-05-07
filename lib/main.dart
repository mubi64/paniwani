import 'package:flutter/material.dart';
import 'package:paniwani/models/restaurant.dart';
import 'package:paniwani/screens/splash_screen.dart';
// import 'utils/app_theme.dart';
import 'api/services/auth_service.dart';
import 'themes/theme_provider.dart';
import 'package:provider/provider.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => Restaurant()),
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: const PaniWaniApp(),
    ),
  );
}

class PaniWaniApp extends StatelessWidget {
  const PaniWaniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      title: 'PaniWani',
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: SplashScreen(),
    );
  }
}
