import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:paniwani/widgets/custom_dropdown.dart';
import 'package:paniwani/widgets/custom_text_field.dart';

import '../api/api_helpers.dart';
import '../api/services/package_service.dart';
import '../models/bottle.dart';
import '../utils/strings.dart';
import '../utils/utils.dart';
import '../widgets/disable_row_field.dart';
import '../widgets/my_quantity_selector_field.dart';
import '../widgets/primary_button.dart';
import 'navigation_bar_screen.dart';

class RentFormScreen extends StatefulWidget {
  bool isSecurityReturn;
  RentFormScreen({super.key, this.isSecurityReturn = false});

  @override
  State<RentFormScreen> createState() => _RentFormScreenState();
}

class _RentFormScreenState extends State<RentFormScreen> {
  Utils utils = Utils();
  List<Bottle> bottleList = [];
  List<String> bottleNameList = [];
  final TextEditingController quantityController = TextEditingController();
  int bottleQuantity = 1;
  Bottle? _selectedBottle;
  bool loading = true;

  String? paymentIntent;

  Future<void> makePayment(price, String currency) async {
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

      await displayPaymentSheet();
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

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      utils.showProgressDialog(context);
      List waterBottles = [
        {
          "water_bottle_product": _selectedBottle!.name.toString(),
          "quantity": bottleQuantity,
        },
      ];
      String bottleResponse = await PackageService().purchaseBottles(
        context,
        waterBottles,
      );
      utils.hideProgressDialog(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NavigationBarScreen()),
      );
      await Stripe.instance.confirmPaymentSheetPayment();
      paymentIntent = null;
    } on StripeException catch (e) {
      print(e.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  void updateQuantity(String value) {
    final enteredQty = int.tryParse(value) ?? 1;
    setState(() {
      bottleQuantity = enteredQty;
      quantityController.text = bottleQuantity.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    quantityController.text = bottleQuantity.toString();
    getBottles();
  }

  void getBottles() async {
    var response = await APIFunction.get(
      context,
      utils,
      APIFunction.bottles,
      '',
    );
    if (response != null) {
      utils.loggerPrint('Bottles fetched successfully');
      var data = response['message'];
      utils.loggerPrint('Data: $data');
      bottleList = [];
      bottleNameList = [];
      setState(() {
        bottleNameList = List<String>.from(data.map((e) => e['name']).toList());
        data.forEach((item) {
          bottleList.add(Bottle.fromJson(item));
        });
        loading = false;
      });
    } else {
      utils.loggerPrint('Failed to fetch bottles: $response');
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isSecurityReturn
              ? AppStrings.securityReturn
              : AppStrings.bottleRent,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                  if (!loading)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: CustomDropdown<Bottle>(
                        hintText: AppStrings.bottle,
                        items: bottleList,
                        selectedValue: _selectedBottle,
                        onChanged: (value) {
                          setState(() {
                            _selectedBottle = value;
                          });
                        },
                        getLabel: (item) {
                          if (item.name != null && item.item != null) {
                            return '${item.item}\n${item.name}';
                          } else if (item.name != null) {
                            return item.name!;
                          } else if (item.item != null) {
                            return item.item!;
                          } else {
                            return 'Unknown';
                          }
                        },
                      ),
                    ),
                  if (_selectedBottle != null)
                    DisableRowField(
                      firstLabel: 'Bottle Type',
                      secondLabel: 'Price',
                      firstValue: _selectedBottle!.bottleType.toString(),
                      secondValue: _selectedBottle!.price.toString(),
                    ),
                  // Add more fields as needed
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: MyQuantitySelectorField(
                      label: "Bottle Quantity",
                      decreaseQuantity: () {
                        if (bottleQuantity > 1) {
                          setState(() {
                            bottleQuantity--;
                            quantityController.text = bottleQuantity.toString();
                          });
                        }
                      },
                      increaseQuantity: () {
                        setState(() {
                          bottleQuantity++;
                          quantityController.text = bottleQuantity.toString();
                        });
                      },
                      quantityController: quantityController,
                      bottleQuantity: bottleQuantity,
                      updateQuantity: updateQuantity,
                    ),
                  ),
                  if (_selectedBottle != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: CustomTextField(
                        controller: TextEditingController(
                          text:
                              (double.parse(_selectedBottle!.price.toString()) *
                                      double.parse(quantityController.text))
                                  .toString(),
                        ),
                        labelText: "Total Price",
                        enabled: false,
                      ),
                    ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 55,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: PrimaryButton(
                text:
                    widget.isSecurityReturn
                        ? AppStrings.securityReturn
                        : AppStrings.pay,
                onPressed: () async {
                  if (_selectedBottle == null) {
                    utils.showToast(
                      "${AppStrings.selectMessage} ${AppStrings.bottle}",
                      context,
                    );
                    return;
                  }
                  utils.showProgressDialog(context);
                  if (widget.isSecurityReturn) {
                    await PackageService().returnBottles(
                      context,
                      _selectedBottle!.name.toString(),
                      bottleQuantity,
                    );
                    utils.hideProgressDialog(context);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NavigationBarScreen(),
                      ),
                      (route) => false,
                    );
                  } else {
                    makePayment(
                      double.parse(_selectedBottle!.price.toString()) *
                          double.parse(quantityController.text),
                      _selectedBottle!.currency.toString(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
