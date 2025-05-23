import 'package:flutter/material.dart';
import 'package:paniwani/models/package.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final Package package;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.package,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(50),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onDecrement,
            child: Icon(
              quantity == 1 ? Icons.delete_outline_rounded : Icons.remove,
              size: 20,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Text(
                quantity.toString(),
                key: ValueKey<int>(quantity), // Important for animation
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: onIncrement,
            child: Icon(
              Icons.add,
              size: 20,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ],
      ),
    );
  }
}
