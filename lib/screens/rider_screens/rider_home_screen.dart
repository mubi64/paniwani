import 'package:flutter/material.dart';
import 'package:paniwani/utils/strings.dart';
import 'package:provider/provider.dart';

import '../../api/services/delivery_order_service.dart';
import '../../models/delivery_order.dart';
import '../../models/restaurant.dart';
import 'order_details_screen.dart';

class RiderHomeScreen extends StatefulWidget {
  int completeOrderScreen;
  RiderHomeScreen({super.key, this.completeOrderScreen = 0});

  @override
  State<RiderHomeScreen> createState() => _RiderHomeScreenState();
}

class _RiderHomeScreenState extends State<RiderHomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<DeliveryOrder> _deliveryOrder = [];
  bool isLoadingDeliveryOrder = true;

  @override
  void initState() {
    super.initState();
    fetchDeliveryOrders();
  }

  Future<void> fetchDeliveryOrders() async {
    isLoadingDeliveryOrder = true;
    if (widget.completeOrderScreen == 0) {
      _deliveryOrder = await DeliveryOrderService().getDeliveryOrders(context);
    } else {
      _deliveryOrder = await DeliveryOrderService().getCompleteOrders(context);
    }
    isLoadingDeliveryOrder = false;
    setState(() {});
  }

  List<DeliveryOrder> get filteredOrders {
    if (_searchQuery.isEmpty) return _deliveryOrder;

    return _deliveryOrder.where((order) {
      final itemMatch =
          order.item?.toLowerCase().contains(_searchQuery) ?? false;
      final addressMatch =
          order.address?.toLowerCase().contains(_searchQuery) ?? false;
      return itemMatch || addressMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          AppStrings.completeOrders,
          style: TextStyle(color: colorScheme.tertiary),
        ),
        backgroundColor: colorScheme.surface,
        iconTheme: IconThemeData(color: colorScheme.tertiary),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by item or address',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          if (isLoadingDeliveryOrder)
            Expanded(child: Center(child: CircularProgressIndicator()))
          else if (filteredOrders.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  AppStrings.noOrdersFound,
                  style: TextStyle(fontSize: 18, color: colorScheme.tertiary),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: filteredOrders.length,
                itemBuilder: (context, index) {
                  final order = filteredOrders[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => OrderDetailsScreen(orderData: order),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.secondary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        spacing: 6,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    order.item.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    order.bottleType.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${order.bottleQuantity} ${AppStrings.bottle}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: colorScheme.tertiaryFixedDim,
                                ),
                              ),
                            ],
                          ),
                          IconRow(
                            Icons.location_on_rounded,
                            order.address.toString(),
                            colorScheme,
                          ),
                          IconRow(
                            Icons.calendar_month_rounded,
                            order.deliveryDate.toString(),
                            colorScheme,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Row IconRow(IconData icon, String text, ColorScheme colorScheme) {
    return Row(
      spacing: 10,
      children: [
        Icon(icon, color: colorScheme.tertiaryFixedDim, size: 18),
        Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.tertiaryFixedDim,
          ),
        ),
      ],
    );
  }
}
