import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:paniwani/widgets/primary_button.dart';

import '../utils/strings.dart';

class CustomProductCard extends StatelessWidget {
  String imagePath;
  String price;
  String productName;
  VoidCallback? onAddPressed;
  Function()? onCardTap;
  CustomProductCard({
    super.key,
    required this.imagePath,
    required this.price,
    required this.productName,
    this.onAddPressed,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(8.0),
        padding: EdgeInsets.all(16.0),
        child: Column(
          spacing: 8.0,
          children: [
            CachedNetworkImage(
              imageUrl: imagePath,
              height: 128,
              fit: BoxFit.contain,
              placeholder:
                  (context, url) =>
                      const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4.0,
              children: [
                Text(
                  productName,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  price,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiaryFixedDim,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: AppStrings.purchase,
                    onPressed: onAddPressed,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      // child: LayoutBuilder(
      //   builder: (context, constraints) {
      //     double cardWidth = constraints.maxWidth * 0.4;
      //     cardWidth = cardWidth.clamp(120.0, 200.0);

      //     double buttonSize = cardWidth * 0.40; // 22% of card width
      //     double iconSize = buttonSize * 0.5;

      //     return Container(
      //       width: cardWidth,
      //       margin: const EdgeInsets.symmetric(horizontal: 8),
      //       decoration: BoxDecoration(
      //         color: Theme.of(context).colorScheme.secondary,
      //         borderRadius: BorderRadius.circular(20),
      //       ),
      //       child: Stack(
      //         children: [
      //           Padding(
      //             padding: const EdgeInsets.symmetric(
      //               vertical: 16,
      //               horizontal: 12,
      //             ),
      //             child: Column(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 const SizedBox(height: 24),
      //                 Expanded(
      //                   child: CachedNetworkImage(
      //                     imageUrl: imagePath,
      //                     fit: BoxFit.contain,
      //                     placeholder:
      //                         (context, url) => const Center(
      //                           child: CircularProgressIndicator(),
      //                         ),
      //                     errorWidget:
      //                         (context, url, error) => const Icon(Icons.error),
      //                   ),
      //                 ),
      //                 const SizedBox(height: 12),
      //                 Text(
      //                   productName,
      //                   style: TextStyle(
      //                     color: Theme.of(context).colorScheme.inversePrimary,
      //                     fontWeight: FontWeight.w500,
      //                   ),
      //                   textAlign: TextAlign.center,
      //                 ),
      //                 const SizedBox(height: 8),
      //               ],
      //             ),
      //           ),
      //           Positioned(
      //             top: 0,
      //             left: 0,
      //             right: 0,
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 Padding(
      //                   padding: const EdgeInsets.only(left: 12.0),
      //                   child: Text(
      //                     price,
      //                     style: TextStyle(
      //                       color: Theme.of(context).colorScheme.inversePrimary,
      //                       fontWeight: FontWeight.bold,
      //                     ),
      //                   ),
      //                 ),
      //                 GestureDetector(
      //                   onTap: onAddPressed,
      //                   child: Container(
      //                     width: buttonSize,
      //                     height: buttonSize,
      //                     decoration: BoxDecoration(
      //                       color: Theme.of(context).colorScheme.inversePrimary,
      //                       borderRadius: const BorderRadius.only(
      //                         topRight: Radius.circular(20),
      //                         bottomLeft: Radius.circular(20),
      //                       ),
      //                     ),
      //                     child: Icon(
      //                       Icons.add,
      //                       size: iconSize,
      //                       color: Theme.of(context).colorScheme.secondary,
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ],
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
