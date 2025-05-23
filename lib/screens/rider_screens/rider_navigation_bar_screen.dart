import 'package:flutter/material.dart';
import 'package:paniwani/screens/orders_screen.dart';
import 'package:paniwani/screens/profile_screen.dart';
import 'package:paniwani/utils/strings.dart';

import '../../api/services/auth_service.dart';
import '../../widgets/custom_appbar.dart';
import 'rider_home_screen.dart';

class RiderNavigationBarScreen extends StatefulWidget {
  final int initialIndex;
  const RiderNavigationBarScreen({super.key, this.initialIndex = 0});

  @override
  State<RiderNavigationBarScreen> createState() =>
      _RiderNavigationBarScreenState();
}

class _RiderNavigationBarScreenState extends State<RiderNavigationBarScreen> {
  final AuthService _authService = AuthService();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  void getUserInfo() async {
    setState(() {
      _selectedIndex = widget.initialIndex;
    });
    await _authService.getCurrentUser(context);
    setState(() {});
  }

  final icons = [
    Icons.home_outlined,
    Icons.assignment_outlined,
    Icons.person_outline,
  ];

  final labels = [AppStrings.home, AppStrings.orders, AppStrings.profile];

  List<Widget> get _screens {
    return [
      RiderHomeScreen(key: UniqueKey()),
      RiderHomeScreen(key: UniqueKey(), completeOrderScreen: 1),
      ProfileScreen(key: UniqueKey()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      // drawer: MyDrawer(),
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
      selectedItemColor: Theme.of(context).colorScheme.inversePrimary,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      unselectedItemColor: Theme.of(context).colorScheme.tertiary,
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
