import 'package:flutter/material.dart';
import 'package:paniwani/models/restaurant.dart';
import 'package:paniwani/screens/splash_screen.dart';
// import 'utils/app_theme.dart';
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

// import 'package:flutter/material.dart';

// void main() => runApp(WaterDeliveryApp());

// class WaterDeliveryApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(home: HomeScreen(), debugShowCheckedModeBanner: false);
//   }
// }

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF0F172A),
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Color(0xFF1E293B),
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.white,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Orders'),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.shopping_cart),
//             label: 'Cart',
//           ),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//         ],
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 HeaderSection(),
//                 const SizedBox(height: 16),
//                 PromotionalBanner(),
//                 const SizedBox(height: 16),
//                 YourPackages(),
//                 const SizedBox(height: 16),
//                 QuickActions(),
//                 const SizedBox(height: 16),
//                 RecentOrders(),
//                 const SizedBox(height: 16),
//                 BottleRentalInfo(),
//                 const SizedBox(height: 16),
//                 AvailablePackages(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class HeaderSection extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Hello, Guest!",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text("Welcome back", style: TextStyle(color: Colors.grey)),
//         const SizedBox(height: 8),
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 12),
//           decoration: BoxDecoration(
//             color: Color(0xFF1E293B),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               dropdownColor: Color(0xFF1E293B),
//               value: 'Home - 123 Street, City',
//               items: [
//                 DropdownMenuItem(
//                   child: Text(
//                     'Home - 123 Street, City',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   value: 'Home - 123 Street, City',
//                 ),
//               ],
//               onChanged: (value) {},
//               iconEnabledColor: Colors.white,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class PromotionalBanner extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.blue,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Text(
//         "Stay Hydrated!",
//         style: TextStyle(color: Colors.white, fontSize: 18),
//       ),
//     );
//   }
// }

// class YourPackages extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           "Your Packages",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         Text("See All", style: TextStyle(color: Colors.blue)),
//       ],
//     );
//   }
// }

// class QuickActions extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: ActionButton(icon: Icons.local_drink, label: "Order Water"),
//         ),
//         SizedBox(width: 12),
//         Expanded(
//           child: ActionButton(icon: Icons.local_shipping, label: "Rent Bottle"),
//         ),
//       ],
//     );
//   }
// }

// class ActionButton extends StatelessWidget {
//   final IconData icon;
//   final String label;

//   const ActionButton({required this.icon, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 80,
//       decoration: BoxDecoration(
//         color: Colors.blue,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, color: Colors.white),
//           SizedBox(height: 4),
//           Text(label, style: TextStyle(color: Colors.white)),
//         ],
//       ),
//     );
//   }
// }

// class RecentOrders extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               "Recent Orders",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Text("View All", style: TextStyle(color: Colors.blue)),
//           ],
//         ),
//         const SizedBox(height: 8),
//         OrderTile(orderId: "#123", date: "Apr 24, 2024", status: "Delivered"),
//         OrderTile(orderId: "#122", date: "Apr 23, 2024", status: "In Progress"),
//       ],
//     );
//   }
// }

// class OrderTile extends StatelessWidget {
//   final String orderId, date, status;

//   const OrderTile({
//     required this.orderId,
//     required this.date,
//     required this.status,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 4),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Color(0xFF1E293B),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("Order $orderId", style: TextStyle(color: Colors.white)),
//               Text(date, style: TextStyle(color: Colors.grey)),
//             ],
//           ),
//           Text(
//             status,
//             style: TextStyle(
//               color: status == 'Delivered' ? Colors.green : Colors.blue,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class BottleRentalInfo extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Color(0xFF1E293B),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("5 Bottles Rented", style: TextStyle(color: Colors.white)),
//               Text(
//                 "Security Deposit: PKR 500",
//                 style: TextStyle(color: Colors.grey),
//               ),
//             ],
//           ),
//           ElevatedButton(onPressed: () {}, child: Text("Return")),
//         ],
//       ),
//     );
//   }
// }

// class AvailablePackages extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               "Available Packages",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Text("View All", style: TextStyle(color: Colors.blue)),
//           ],
//         ),
//         const SizedBox(height: 8),
//         SizedBox(
//           height: 160,
//           child: ListView(
//             scrollDirection: Axis.horizontal,
//             children: [
//               PackageListItem(label: "100 Bottle Package", price: "PKR 10,000"),
//               PackageListItem(label: "50 Bottle Package", price: "PKR 5,000"),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class PackageListItem extends StatelessWidget {
//   final String label, price;

//   const PackageListItem({required this.label, required this.price});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 140,
//       margin: const EdgeInsets.only(right: 12),
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Color(0xFF1E293B),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Icon(Icons.local_drink, color: Colors.white, size: 60),
//           ),
//           Text(label, style: TextStyle(color: Colors.white)),
//           Text(price, style: TextStyle(color: Colors.grey)),
//           ElevatedButton(onPressed: () {}, child: Text("Purchase")),
//         ],
//       ),
//     );
//   }
// }
