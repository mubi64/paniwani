import 'package:flutter/material.dart';
import 'package:paniwani/models/restaurant.dart';
import 'package:paniwani/screens/splash_screen.dart';
import 'api/services/auth_service.dart';
import 'themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main() async {
  await initStripe();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => Restaurant()),
      ],
      child: const PaniWaniApp(),
    ),
  );
}

Future<void> initStripe() async {
  // Initialize Stripe with your publishable key
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51RHNY8QT530vswKbR65d5vSbhvyoyWff0k9N7z2NIoPLBxhRhCiP3B6z2nvmDvte5Vaen9PTaSa2DfaYIDPXlw5u00wL3aBMeL";
  await Stripe.instance.applySettings();
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
