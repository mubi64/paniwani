import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
                return Container(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${AppStrings.order} #${order.name}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.tertiaryFixedDim,
                                  ),
                                ),
                                Text(
                                  DateFormat('MMM dd, yyyy')
                                      .format(
                                        DateTime.parse(
                                          order.deliveryDate.toString(),
                                        ),
                                      )
                                      .toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Container(
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
                          ),
                        ],
                      ),
                      Divider(
                        color: Theme.of(context).colorScheme.tertiaryFixedDim,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${order.customer}',
                            style: TextStyle(
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.tertiaryFixedDim,
                            ),
                          ),
                          Text(
                            '${order.bottleType}',
                            style: TextStyle(
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.tertiaryFixedDim,
                            ),
                          ),
                          Text(
                            '${order.address}',
                            style: TextStyle(
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.tertiaryFixedDim,
                            ),
                          ),
                        ],
                      ),
                    ],
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
