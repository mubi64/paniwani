import 'package:flutter/material.dart';

class AddressBox extends StatelessWidget {
  String addressTitle;
  String addressDetails;
  Function()? onEditPressed;
  AddressBox({
    super.key,
    required this.addressTitle,
    required this.addressDetails,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Delivery Address",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(
                  Icons.edit_rounded,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                onPressed: onEditPressed,
              ),
            ],
          ),
          Divider(
            color: Theme.of(context).colorScheme.tertiaryFixedDim,
            thickness: 1,
            height: 20,
          ),
          Text(
            addressTitle,
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            addressDetails,
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiaryFixedDim,
            ),
          ),
        ],
      ),
    );
  }
}
