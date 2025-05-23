import 'package:flutter/material.dart';

class CustomDatePicker extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  Function() onDateSelected;
  String? hintText;
  IconData? icon;
  CustomDatePicker({
    super.key,
    required this.controller,
    required this.onDateSelected,
    this.hintText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2.0),
          child: Text(
            hintText.toString(),
            style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
          ),
        ),
        GestureDetector(
          onTap: onDateSelected,
          child: AbsorbPointer(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                filled: true,
                fillColor: Theme.of(context).colorScheme.secondary,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: Icon(icon),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
