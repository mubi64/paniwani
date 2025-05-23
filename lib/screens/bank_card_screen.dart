import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:paniwani/api/api_helpers.dart';
import 'package:paniwani/models/cart_item.dart';
import 'package:paniwani/screens/place_order_screen.dart';

import '../api/services/package_service.dart';
import '../models/bottle.dart';
import '../models/restaurant.dart';
import '../utils/comman_dialogs.dart';
import '../utils/strings.dart';
import '../utils/utils.dart';
import '../widgets/primary_button.dart';
import 'navigation_bar_screen.dart';
import 'payment_result_screen.dart';

class BankCardScreen extends StatefulWidget {
  List<CartItem>? cart;
  Bottle? bottle;
  int? qty;
  BankCardScreen({super.key, this.cart, this.bottle, this.qty});

  @override
  State<BankCardScreen> createState() => _BankCardScreenState();
}

class _BankCardScreenState extends State<BankCardScreen> {
  Utils utils = Utils();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  void confirmPay() async {
    Navigator.pop(context);
    utils.hideKeyboard(context);
    utils.showProgressDialog(context, text: AppStrings.makeInvoice);

    try {
      Map<String, String> exMonthYear = parseMonthYear(expiryDate);

      if (widget.bottle != null) {
        List bottles = [
          {
            "water_bottle_product": widget.bottle!.name.toString(),
            "quantity": widget.qty,
          },
        ];

        stripPay(exMonthYear, 1, '', bottles);
      } else {
        String response = await PackageService().purchasePackage(
          context,
          widget.cart!
              .map(
                (item) => {
                  "bottle_package": item.package.name,
                  "qty": item.quantity,
                },
              )
              .toList(),
        );
        Restaurant().clearCart();
        utils.hideProgressDialog(context);
        if (response != '') {
          stripPay(exMonthYear, 0, response.toString(), []);
        }
      }
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context);
      utils.showToast('Error: ${e.toString()}', context);
    }
  }

  stripPay(
    exMonthYear,
    int isBottleRent,
    String invoice,
    List waterBottles,
  ) async {
    utils.showProgressDialog(context, text: AppStrings.paymentProcess);
    try {
      var response = await PackageService().makePayment(
        context,
        cardNumber,
        exMonthYear['month']!,
        exMonthYear['year']!,
        cvvCode,
        isBottleRent,
        invoice,
        waterBottles,
      );
      utils.hideProgressDialog(context);
      if (response != null && response['message']['status'] == 'succeeded') {
        if (isBottleRent == 1) {
          utils.showProgressDialog(context, text: AppStrings.updateBottleQty);
          String bottleResponse = await PackageService().purchaseBottles(
            context,
            waterBottles,
          );
          utils.showToast(
            bottleResponse.isNotEmpty ? bottleResponse : 'Something went wrong',
            context,
          );
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (_) => PaymentResultScreen(isSuccess: true, data: response),
          ),
        );
      } else {
        utils.hideProgressDialog(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (_) => PaymentResultScreen(
                  isSuccess: false,
                  data: response ?? {'exception': 'Unknown error occurred'},
                ),
          ),
        );
      }
    } catch (e) {
      utils.hideProgressDialog(context);
      print('Error My print: $e');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (_) => PaymentResultScreen(
                isSuccess: false,
                data: {'exception': e.toString(), 'exc_type': 'Exception'},
              ),
        ),
      );
    }
  }

  void userTappedPay() {
    if (formKey.currentState!.validate()) {
      dialogConfirm(context, utils, confirmPay, AppStrings.comfirmationMessage);
    }
  }

  Map<String, String> parseMonthYear(String input) {
    final parts = input.split('/');
    final month = parts[0];
    final year = '20${parts[1]}';
    return {'month': month, 'year': year};
  }

  CardFieldInputDetails? _card;
  bool _loading = false;

  Future<void> _makePayment() async {
    setState(() => _loading = true);

    try {
      // Step 1: Create PaymentIntent on backend
      final response = await APIFunction.postJson(
        context,
        utils,
        "https://yourdomain.com/api/method/frappe_app.api.stripe_payment.create_payment_intent?amount=500",
        {
          'amount': 500, // Amount in cents
          'currency': 'usd',
          'payment_method_types[]': 'card',
        },
        '',
      );
      final data = jsonDecode(response.body);
      final clientSecret = data['message']['client_secret'];

      // Step 2: Confirm payment on client
      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: '$clientSecret',
        data: PaymentMethodParams.card(paymentMethodData: PaymentMethodData()),
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Payment successful!")));
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Payment failed: $e")));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Stripe Payment")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // CardField(onCardChanged: (card) => _card = card),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _card?.complete == true ? _makePayment : null,
              child:
                  _loading ? CircularProgressIndicator() : Text("Pay \$5.00"),
            ),
          ],
        ),
      ),
    );
    // return Scaffold(
    //   backgroundColor: Theme.of(context).colorScheme.surface,
    //   appBar: AppBar(
    //     title: Text(
    //       "Checkout",
    //       style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
    //     ),
    //   ),
    //   body: SingleChildScrollView(
    //     child: Column(
    //       children: [
    //         CreditCardWidget(
    //           cardNumber: cardNumber,
    //           expiryDate: expiryDate,
    //           cardHolderName: cardHolderName,
    //           cvvCode: cvvCode,
    //           showBackView: isCvvFocused,
    //           onCreditCardWidgetChange: (p0) {},
    //           isHolderNameVisible: true,
    //         ),
    //         //   credit card form
    //         CreditCardForm(
    //           cardNumber: cardNumber,
    //           expiryDate: expiryDate,
    //           cardHolderName: cardHolderName,
    //           cvvCode: cvvCode,
    //           onCreditCardModelChange: (data) {
    //             setState(() {
    //               cardNumber = data.cardNumber;
    //               expiryDate = data.expiryDate;
    //               cardHolderName = data.cardHolderName;
    //               cvvCode = data.cvvCode;
    //             });
    //           },
    //           formKey: formKey,
    //         ),
    //         SizedBox(height: 25),
    //         Container(
    //           padding: const EdgeInsets.symmetric(horizontal: 8.0),
    //           width: double.infinity,
    //           height: 55,
    //           child: PrimaryButton(
    //             onPressed: userTappedPay,
    //             text: AppStrings.payNow,
    //           ),
    //         ),
    //         SizedBox(height: 25),
    //       ],
    //     ),
    //   ),
    // );
  }
}
