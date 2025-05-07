import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/restaurant.dart';
import '../utils/strings.dart';
import '../widgets/skeleton.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  void _fetchData() {
    final restaurant = context.read<Restaurant>();
    restaurant.fetchCustomerOrders(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<Restaurant>(
        builder: (context, restaurant, child) {
          var orders = restaurant.customerOrders;
          var loading = restaurant.isLoadingCustomerOrder;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: loading ? 3 : orders.length,
            itemBuilder: (context, index) {
              if (loading) {
                return Padding(
                  padding: const EdgeInsets.only(
                    right: 20.0,
                    left: 20,
                    bottom: 16,
                  ),
                  child: Skeleton(height: 200, width: 300, radius: 12),
                );
              } else {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      'Order #${order.name}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text('Date: ${order.deliveryDate}'),
                        Text('Bundle: ${order.bottleType}'),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                order.status == 'Delivered'
                                    ? Colors.green.shade100
                                    : Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '${order.status}',
                            style: TextStyle(
                              color:
                                  order.status == 'Delivered'
                                      ? Colors.green.shade800
                                      : Colors.orange.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () {
                        // Show order details
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "View details for Order #${order.name}",
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
