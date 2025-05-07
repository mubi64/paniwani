import 'package:flutter/material.dart';
import 'package:paniwani/api/services/auth_service.dart';

import '../screens/bottle_rent_screen.dart';
import 'my_drawer_tile.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  void logout() async {
    final authService = AuthService();
    await authService.logout(context);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // logo
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Icon(
              Icons.water_damage_rounded,
              size: 80,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Divider(color: Theme.of(context).colorScheme.secondary),
          ),
          // setting
          MyDrawerTile(
            text: "R E N T A L",
            icon: Icons.attach_money_rounded,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BottleRentScreen(),
                ),
              );
            },
          ),
          Spacer(),
          // log out
          MyDrawerTile(
            text: "L O G O U T",
            icon: Icons.logout,
            onTap: () => logout,
          ),
          SizedBox(height: 25),
        ],
      ),
    );
  }
}
