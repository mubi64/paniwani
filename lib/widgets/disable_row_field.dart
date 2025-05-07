import 'package:flutter/material.dart';

import 'custom_text_field.dart';

class DisableRowField extends StatelessWidget {
  String firstLabel;
  String secondLabel;
  String firstValue;
  String secondValue;
  DisableRowField({
    super.key,
    required this.firstLabel,
    required this.secondLabel,
    required this.firstValue,
    required this.secondValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              controller: TextEditingController(text: firstValue),
              labelText: firstLabel,
              enabled: false,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CustomTextField(
              controller: TextEditingController(text: secondValue),
              labelText: secondLabel,
              enabled: false,
            ),
          ),
        ],
      ),
    );
  }
}
