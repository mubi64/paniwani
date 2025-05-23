import 'package:flutter/material.dart';

class NavigateButton extends StatelessWidget {
  IconData? icon;
  Function() onPressed;
  NavigateButton({super.key, this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
      ),
      margin: const EdgeInsets.only(left: 25.0),
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
        color: colorScheme.inversePrimary,
      ),
    );
  }
}
