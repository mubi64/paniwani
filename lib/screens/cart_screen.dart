import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:paniwani/api/api_helpers.dart';
import 'package:provider/provider.dart';

import '../api/services/package_service.dart';
import '../models/restaurant.dart';
import '../utils/comman_dialogs.dart';
import '../utils/strings.dart';
import '../utils/utils.dart';
import '../widgets/my_cart_tile.dart';
import '../widgets/primary_button.dart';
import 'navigation_bar_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Utils utils = Utils();

  String? paymentIntent;

  Future<void> makePayment(cart, price, String currency) async {
    try {
      paymentIntent = await createPaymentIntent(price, currency);
      utils.hideProgressDialog(context);
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: false,
          merchantDisplayName: 'Paniwani',
          paymentIntentClientSecret: paymentIntent,
          googlePay: PaymentSheetGooglePay(
            merchantCountryCode: 'PK',
            currencyCode: currency,
            testEnv: true,
          ),
        ),
      );

      await displayPaymentSheet(cart);
    } catch (e) {
      print('error on line 46: ${e.toString()}');
    }
  }

  createPaymentIntent(double amount, String currency) async {
    try {
      var formData = {'amount': amount * 100, 'currency': currency};

      var response = await APIFunction.postJson(
        context,
        utils,
        APIFunction.createClientSecret,
        formData,
        '',
      );
      print('maira response : $response');
      if (response != null) {
        return response.data['message'];
      } else {
        utils.showToast(response.data['message'], context);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  displayPaymentSheet(cart) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      utils.showProgressDialog(context);
      String response = await PackageService().purchasePackage(
        context,
        cart!
            .map(
              (item) => {
                "bottle_package": item.package.name,
                "qty": item.quantity,
              },
            )
            .toList(),
      );
      utils.hideProgressDialog(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NavigationBarScreen()),
      );
      Provider.of<Restaurant>(context, listen: false).clearCart();
      await Stripe.instance.confirmPaymentSheetPayment();
      paymentIntent = null;
    } on StripeException catch (e) {
      print(e.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(
      builder: (context, restaurant, child) {
        final userCart = restaurant.cart;
        return Scaffold(
          appBar: AppBar(
            title: Text(AppStrings.cart),
            actions: [
              // clear all cart
              IconButton(
                onPressed: () {
                  if (userCart.isEmpty) {
                    utils.showToast(AppStrings.cartEmpty, context);
                    return;
                  }
                  dialogConfirm(context, utils, () {
                    restaurant.clearCart();
                    Navigator.pop(context);
                  }, AppStrings.clearCartConfirmation);
                },
                icon: Icon(Icons.delete),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      if (userCart.isEmpty)
                        Expanded(
                          child: Center(
                            child: Text("${AppStrings.cartEmpty}..."),
                          ),
                        )
                      else
                        Expanded(
                          child: ListView.builder(
                            itemCount: userCart.length,
                            itemBuilder: (context, index) {
                              final cartItem = userCart[index];
                              return MyCartTile(cartItem: cartItem);
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                if (userCart.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 25,
                    ),
                    child: Column(
                      children: [
                        // total price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total ",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(restaurant.getTotalPriceWithCurrency()),
                          ],
                        ),
                        Divider(
                          color: Theme.of(context).colorScheme.primary,
                          thickness: 1,
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: PrimaryButton(
                            onPressed: () async {
                              utils.showProgressDialog(context);
                              makePayment(
                                userCart,
                                restaurant.getTotalPrice(),
                                userCart[0].package.currency.toString(),
                              );
                            },
                            text: "Checkout",
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
