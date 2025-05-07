import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? selectedValue;
  final List<T> items;
  final String Function(T) getLabel;
  final Function(T?)? onChanged;
  final String? hintText;
  bool isDynamic;
  CustomDropdown({
    super.key,
    this.selectedValue,
    required this.getLabel,
    required this.items,
    this.onChanged,
    this.hintText,
    this.isDynamic = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            hintText.toString(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(30),
          ),
          child: DropdownButtonFormField<T>(
            value: selectedValue,
            decoration: const InputDecoration(border: InputBorder.none),
            hint: Text(hintText.toString()),
            items:
                items.map((value) {
                  return DropdownMenuItem<T>(
                    value: value,
                    child: Text(getLabel(value)),
                  );
                }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
