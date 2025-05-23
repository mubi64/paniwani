import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/customer_bottle.dart';
import '../models/restaurant.dart';
import '../utils/strings.dart';
import 'rent_form_screen.dart';

class BottleRentScreen extends StatefulWidget {
  const BottleRentScreen({super.key});

  @override
  State<BottleRentScreen> createState() => _BottleRentScreenState();
}

class _BottleRentScreenState extends State<BottleRentScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch the menu when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Restaurant>().fetchCustomerBottles(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.bottleRent)),
      body: Consumer<Restaurant>(
        builder: (context, restaurant, child) {
          var bottles = restaurant.customerBottles;
          if (bottles.isEmpty) {
            return Center(
              child: Text(
                AppStrings.noBottlesAvailable,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }
          return ListView.builder(
            itemCount: bottles.length,
            itemBuilder: (context, index) {
              return buildBottleInfoCard(bottles[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RentFormScreen()),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget buildBottleInfoCard(CustomerBottle data) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.item.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          const SizedBox(height: 8),
          _buildRow(AppStrings.bottleType, data.bottleType.toString()),
          _buildRow(AppStrings.availableQty, data.availableQuantity.toString()),
          _buildRow(AppStrings.companyHand, data.companyHand.toString()),
          _buildRow(AppStrings.customerHand, data.customerHand.toString()),
          _buildRow(AppStrings.price, (data.price ?? 0).toStringAsFixed(0)),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          Text(
            value,
            style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
          ),
        ],
      ),
    );
  }
}
