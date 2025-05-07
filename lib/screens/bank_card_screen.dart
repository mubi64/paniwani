import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
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
        String response = await PackageService().purchaseBottles(
          context,
          bottles,
          cardNumber,
          exMonthYear['month']!,
          exMonthYear['year']!,
          cvvCode,
        );
        utils.hideProgressDialog(context);
        if (response != '') {
          stripPay(exMonthYear, 1, '', bottles);
        }
        utils.showToast(
          response.isNotEmpty ? response : 'Something went wrong',
          context,
        );
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
          cardNumber,
          exMonthYear['month']!,
          exMonthYear['year']!,
          cvvCode,
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
      debugPrint("I need to check data: ${response['message']} ");
      if (response != null && response['message']['status'] == 'succeeded') {
        utils.hideProgressDialog(context);
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Checkout"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              onCreditCardWidgetChange: (p0) {},
              isHolderNameVisible: true,
            ),
            //   credit card form
            CreditCardForm(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              onCreditCardModelChange: (data) {
                setState(() {
                  cardNumber = data.cardNumber;
                  expiryDate = data.expiryDate;
                  cardHolderName = data.cardHolderName;
                  cvvCode = data.cvvCode;
                });
              },
              formKey: formKey,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PrimaryButton(onPressed: userTappedPay, text: 'Pay now'),
            ),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
