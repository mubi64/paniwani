import 'package:flutter/material.dart';
import 'package:paniwani/screens/home_screen.dart';
import 'package:paniwani/screens/orders_screen.dart';
import 'package:paniwani/screens/profile_screen.dart';
import 'package:paniwani/utils/strings.dart';
import 'package:paniwani/widgets/my_drawer.dart';

import '../api/services/auth_service.dart';
import '../widgets/custom_appbar.dart';
import 'place_order_screen.dart';

class NavigationBarScreen extends StatefulWidget {
  final int initialIndex;
  const NavigationBarScreen({super.key, this.initialIndex = 0});

  @override
  State<NavigationBarScreen> createState() => _NavigationBarScreenState();
}

class _NavigationBarScreenState extends State<NavigationBarScreen> {
  final AuthService _authService = AuthService();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  void getUserInfo() async {
    await _authService.getCurrentUser(context);
    _selectedIndex = widget.initialIndex;
    setState(() {});
  }

  final icons = [
    Icons.home_outlined,
    Icons.shopping_cart_outlined,
    Icons.person_outline,
  ];

  final labels = [AppStrings.home, AppStrings.orders, AppStrings.profile];

  final List<Widget> _screens = [HomeScreen(), OrdersScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: MyDrawer(),
      appBar: _buildAppbar(),
      body: SafeArea(
        child: Column(children: [Expanded(child: _screens[_selectedIndex])]),
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

  _buildAppbar() {
    return CustomAppBar(title: labels[_selectedIndex]);
  }
}
