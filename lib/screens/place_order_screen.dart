import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paniwani/api/services/package_service.dart';
import 'package:paniwani/models/purchased_package.dart';
import 'package:paniwani/screens/create_address_screen.dart';
import 'package:paniwani/utils/utils.dart';
import 'package:provider/provider.dart';

import '../api/services/address_service.dart';
import '../models/address.dart';
import '../models/restaurant.dart';
import '../utils/strings.dart';
import '../widgets/address_box.dart';
import '../widgets/custom_date_picker.dart';
import '../widgets/disable_row_field.dart';
import '../widgets/my_quantity_selector_field.dart';
import '../widgets/primary_button.dart';
import 'navigation_bar_screen.dart';

class PlaceOrderScreen extends StatefulWidget {
  PurchasedPackage package;
  PlaceOrderScreen({super.key, required this.package});

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  Utils utils = Utils();
  int selectedIndex = 0;
  List<Address> addresses = [];
  Address selectedAddress = Address();
  int bottleQuantity = 1;
  final TextEditingController quantityController = TextEditingController();

  final TextEditingController deliveryDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    quantityController.text = bottleQuantity.toString();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Restaurant>().fetchPurchasedPackages(context);
    });
    getAddresses();
  }

  void getAddresses() async {
    addresses = await AddressService().getAddresses(context);
    if (addresses.isNotEmpty) {
      selectedIndex = addresses.indexWhere(
        (address) => address.isShippingAddress == 1,
      );
      selectedIndex = selectedIndex < 0 ? 0 : selectedIndex;
      selectedAddress = addresses[selectedIndex];
    }
    setState(() {});
  }

  void updateQuantity(String value) {
    final enteredQty = int.tryParse(value) ?? 1;
    if (enteredQty <= (widget.package.bottlesRemaining ?? 0)) {
      setState(() {
        bottleQuantity = enteredQty;
      });
    } else {
      // Reset to max allowed
      setState(() {
        bottleQuantity = (widget.package.bottlesRemaining ?? 0);
        quantityController.text = widget.package.bottlesRemaining.toString();
      });
      utils.showToast(
        "You cannot order more than ${widget.package.bottlesRemaining} bottles.",
        context,
      );
    }
  }

  _datePicker() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        deliveryDateController.text = DateFormat('yyyy-MM-dd').format(date);
      });
    }
  }

  void showAddressBottomSheet() async {
    final selected = await showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              child: Column(
                children: [
                  Container(
                    height: 4,
                    width: 40,
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            'Select Address',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: addresses.length,
                            itemBuilder: (context, index) {
                              final address = addresses[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 10,
                                ),
                                elevation: selectedIndex == index ? 2 : 0,
                                color: Theme.of(context).colorScheme.secondary,
                                child: RadioListTile(
                                  value: index,
                                  groupValue: selectedIndex,
                                  onChanged: (val) {
                                    setState(() {
                                      selectedIndex = val as int;
                                    });
                                  },
                                  title: Text(
                                    address.name.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(address.addressLine1.toString()),
                                    ],
                                  ),
                                  secondary: Icon(Icons.edit, size: 20),
                                ),
                              );
                            },
                          ),
                        ),
                        Divider(
                          color: Theme.of(context).colorScheme.primary,
                          thickness: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              IconButton(
                                icon: Row(
                                  children: [
                                    Icon(Icons.add),
                                    SizedBox(width: 8),
                                    Text(
                                      "Add New Address",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => CreateAddressScreen(),
                                      // const SearchLocationScreen(),
                                    ),
                                  );
                                },
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedAddress =
                                            addresses[selectedIndex];
                                      });
                                      Navigator.pop(
                                        context,
                                        addresses[selectedIndex],
                                      );
                                    },
                                    child: Text(
                                      "Confirm",
                                      style: TextStyle(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    if (selected != null) {
      setState(() {
        selectedAddress = selected;
      });
    }
  }

  void _placeOrder() async {
    if (selectedAddress.addressLine1 == null) {
      utils.showToast("Please select an address", context);
      return;
    }
    if (deliveryDateController.text.isEmpty) {
      utils.showToast("Please select a delivery date", context);
      return;
    }
    utils.showProgressDialog(context, text: "Loading...");
    try {
      await Restaurant().orderPlace(
        context,
        widget.package.name.toString(),
        bottleQuantity,
        deliveryDateController.text,
        selectedAddress.name.toString(),
      );
      Navigator.pop(context);
      utils.showToast("Order placed successfully", context);
    } catch (e) {
      utils.showToast("Failed to place order. Please try again.", context);
    } finally {
      utils.hideProgressDialog(context);
    }
  }

  @override
  void dispose() {
    quantityController.dispose();
    deliveryDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.orderPlace,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
            Text(
              widget.package.item.toString(),
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                spacing: 12,
                children: [
                  AddressBox(
                    addressTitle:
                        selectedAddress.name != null
                            ? selectedAddress.name.toString()
                            : AppStrings.address,
                    addressDetails:
                        selectedAddress.addressLine1 != null
                            ? selectedAddress.addressLine1.toString()
                            : AppStrings.selectAddress,
                    onEditPressed: showAddressBottomSheet,
                  ),
                  DisableRowField(
                    firstLabel: 'Purchased',
                    secondLabel: 'Remaining',
                    firstValue: widget.package.bottlesPurchased.toString(),
                    secondValue: widget.package.bottlesRemaining.toString(),
                  ),

                  // Editable field: bottle_quantity with +/- buttons
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
                      if (bottleQuantity <
                          (widget.package.bottlesRemaining ?? 0)) {
                        setState(() {
                          bottleQuantity++;
                          quantityController.text = bottleQuantity.toString();
                        });
                      } else {
                        utils.showToast(
                          "You cannot order more than ${widget.package.bottlesRemaining} bottles.",
                          context,
                        );
                      }
                    },
                    quantityController: quantityController,
                    bottleQuantity: bottleQuantity,
                    updateQuantity: updateQuantity,
                  ),

                  // Editable field: delivery_date (Date picker)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CustomDatePicker(
                      controller: deliveryDateController,
                      hintText: 'Delivery Date',
                      onDateSelected: () => _datePicker(),
                      icon: Icons.calendar_today,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            height: 55,
            child: PrimaryButton(onPressed: _placeOrder, text: "Place Order"),
          ),
          SizedBox(height: 25),
        ],
      ),
    );
  }
}
