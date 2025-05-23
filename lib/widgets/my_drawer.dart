import 'package:flutter/material.dart';

import '../screens/bottle_rent_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/rider_screens/rider_home_screen.dart';
import '../screens/security_return_screen.dart';
import 'my_drawer_tile.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
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
          // MyDrawerTile(
          //   text: "R E N T A L",
          //   icon: Icons.attach_money_rounded,
          //   onTap: () {
          //     Navigator.pop(context);
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const BottleRentScreen(),
          //       ),
          //     );
          //   },
          // ),
          // MyDrawerTile(
          //   text: "R E T U R N",
          //   icon: Icons.change_circle_rounded,
          //   onTap: () {
          //     Navigator.pop(context);
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const SecurityReturnScreen(),
          //       ),
          //     );
          //   },
          // ),
          MyDrawerTile(
            text: "P R O F I L E",
            icon: Icons.person_rounded,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          MyDrawerTile(
            text: "O R D E R S",
            icon: Icons.local_shipping_rounded,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RiderHomeScreen(completeOrderScreen: 1),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
