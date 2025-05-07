import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/customer_bottle.dart';
import '../models/restaurant.dart';
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
      appBar: AppBar(title: Text("Bottle Rental")),
      body: Consumer<Restaurant>(
        builder: (context, restaurant, child) {
          var bottles = restaurant.customerBottles;
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
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildBottleInfoCard(CustomerBottle data) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.item,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildRow("Bottle Type", data.bottleType),
            _buildRow("Available Quantity", data.availableQuantity.toString()),
            _buildRow("Company Hand", data.companyHand.toString()),
            _buildRow("Customer Hand", data.customerHand.toString()),
            _buildRow("Price ", data.price.toStringAsFixed(0)),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }
}
