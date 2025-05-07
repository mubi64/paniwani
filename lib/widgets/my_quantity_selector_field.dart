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
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                label,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(30),
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
