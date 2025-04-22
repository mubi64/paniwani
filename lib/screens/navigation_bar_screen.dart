import 'package:flutter/material.dart';
import 'package:paniwani/screens/home_screen.dart';
import 'package:paniwani/screens/orders_screen.dart';
import 'package:paniwani/screens/profile_screen.dart';
import 'package:paniwani/utils/strings.dart';

class NavigationBarScreen extends StatefulWidget {
  const NavigationBarScreen({super.key});

  @override
  State<NavigationBarScreen> createState() => _NavigationBarScreenState();
}

class _NavigationBarScreenState extends State<NavigationBarScreen> {
  int _selectedIndex = 0;

  final icons = [
    Icons.home_outlined,
    Icons.shopping_cart_outlined,
    Icons.person_outline,
  ];

  final labels = [AppStrings.home, AppStrings.orders, AppStrings.profile];

  final List<Widget> _screens = [
    HomeScreen(),
    OrdersScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppbar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _screens[_selectedIndex],
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
   
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      selectedItemColor: const Color(0xFF1D9E83),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      items: List.generate(icons.length, (index) {
        return BottomNavigationBarItem(
          icon: Icon(icons[index]),
          label: labels[index],
        );
      }),
    );
  }

  AppBar _buildAppbar() {
      return AppBar(
          title: Text(labels[_selectedIndex])
        );

  }
}