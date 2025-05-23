import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  String? labelText;
  String? Function(String?)? onValidate;
  TextInputType? keyboardType;
  bool? enabled;
  CustomTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.onValidate,
    this.keyboardType,
    this.enabled,
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
            labelText.toString(),
            style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
          ),
        ),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: labelText,
            filled: true,
            fillColor: Theme.of(context).colorScheme.secondary,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          keyboardType: keyboardType,
          validator: onValidate,
          enabled: enabled,
        ),
      ],
    );
  }
}
