import 'package:flutter/material.dart';
import 'package:paniwani/widgets/custom_dropdown.dart';
import 'package:paniwani/widgets/custom_text_field.dart';

import '../api/api_helpers.dart';
import '../models/bottle.dart';
import '../utils/strings.dart';
import '../utils/utils.dart';
import '../widgets/disable_row_field.dart';
import '../widgets/my_quantity_selector_field.dart';
import '../widgets/primary_button.dart';
import 'bank_card_screen.dart';

class RentFormScreen extends StatefulWidget {
  const RentFormScreen({super.key});

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
      appBar: AppBar(title: const Text("Rent Form")),
      body: Column(
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
                MyQuantitySelectorField(
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: PrimaryButton(
              text: 'Pay',
              onPressed: () {
                if (_selectedBottle == null) {
                  utils.showToast(
                    "${AppStrings.selectMessage} ${AppStrings.bottle}",
                    context,
                  );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => BankCardScreen(
                          bottle: _selectedBottle,
                          qty: int.parse(quantityController.text),
                        ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
