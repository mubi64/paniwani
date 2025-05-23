import 'package:flutter/material.dart';

class MyQuantitySelectorField extends StatelessWidget {
  String label;
  final Function() decreaseQuantity;
  final Function() increaseQuantity;
  final TextEditingController quantityController;
  int bottleQuantity;
  final Function(String) updateQuantity;

  MyQuantitySelectorField({
    super.key,
    required this.label,
    required this.decreaseQuantity,
    required this.increaseQuantity,
    required this.quantityController,
    required this.bottleQuantity,
    required this.updateQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12.0),
          child: Text(
            label,
            style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: decreaseQuantity,
              ),
              Expanded(
                child: TextFormField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  onChanged: updateQuantity,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: increaseQuantity,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
