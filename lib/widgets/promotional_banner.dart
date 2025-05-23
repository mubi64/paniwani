import 'package:flutter/material.dart';
import 'package:paniwani/utils/strings.dart';

class PromotionalBanner extends StatelessWidget {
  const PromotionalBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        AppStrings.promossionMessage,
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
