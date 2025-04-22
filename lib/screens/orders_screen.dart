import 'package:flutter/material.dart';
import '../utils/strings.dart';

class OrdersScreen extends StatelessWidget {
  OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy orders data
    final orders = [
      {
        'id': 'ORD12345',
        'date': '15 Apr 2025',
        'bundle': 'Basic Water Supply',
        'status': 'Delivered',
      },
      {
        'id': 'ORD12346',
        'date': '10 Apr 2025',
        'bundle': 'Premium Water Supply',
        'status': 'In Progress',
      },
      {
        'id': 'ORD12347',
        'date': '05 Apr 2025',
        'bundle': 'Standard Water Supply',
        'status': 'Delivered',
      },
    ];

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                'Order #${order['id']}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text('Date: ${order['date']}'),
                  Text('Bundle: ${order['bundle']}'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: order['status'] == 'Delivered'
                          ? Colors.green.shade100
                          : Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '${order['status']}',
                      style: TextStyle(
                        color: order['status'] == 'Delivered'
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
                    SnackBar(content: Text("View details for Order #${order['id']}")),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}