import 'package:flutter/material.dart';
import 'package:paniwani/models/user.dart';
import 'package:paniwani/storage/shared_pref.dart';
import 'package:provider/provider.dart';

import '../models/restaurant.dart';
import '../screens/cart_screen.dart';
import '../utils/comman_dialogs.dart';
import '../utils/strings.dart';
import '../utils/utils.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  CustomAppBar({super.key, required this.title});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  Utils utils = Utils();
  final SharedPref _prefs = SharedPref();
  User? user = User();

  @override
  void initState() {
    super.initState();
    initUser();
  }

  void initUser() async {
    _prefs.readObject(_prefs.prefKeyUserData).then((value) {
      setState(() {
        user = User.fromJson(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:
          widget.title == "Home"
              ? Theme.of(context).colorScheme.surface
              : Theme.of(context).colorScheme.secondary,
      elevation: 4,
      title:
          widget.title == "Home"
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${AppStrings.hello}, ${user?.fullName ?? ''}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    AppStrings.welcomeBack,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiaryFixedDim,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              )
              : Text(
                widget.title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontWeight: FontWeight.bold,
                ),
              ),
      // centerTitle: true,
      actions: [
        if (widget.title == "Home")
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => CartScreen()),
              // );
            },
          ),
        if (user!.waterDeliveryBoy == false)
          Consumer<Restaurant>(
            builder: (context, restaurant, child) {
              final cart = restaurant.cart;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartScreen()),
                  );
                },
                child: Stack(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.shopping_cart_outlined,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CartScreen()),
                        );
                      },
                    ),
                    if (cart.isNotEmpty)
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 20,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${cart.length}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.surface,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),

        // if (title == "Cart")
        //   IconButton(
        //     onPressed: () {
        //       if (cart.isEmpty) {
        //         utils.showToast(AppStrings.cartEmpty, context);
        //         return;
        //       }
        //       dialogConfirm(context, utils, () {
        //         restaurant.clearCart();
        //         Navigator.pop(context);
        //       }, AppStrings.clearCartConfirmation);
        //     },
        //     icon: Icon(Icons.delete),
        //   ),
      ],
    );
  }
}
