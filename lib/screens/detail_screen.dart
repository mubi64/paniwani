import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/package.dart';
import '../models/restaurant.dart';
import '../storage/shared_pref.dart';
import '../widgets/primary_button.dart';

class DetailScreen extends StatefulWidget {
  final Package package;
  final String baseUrl;
  const DetailScreen({super.key, required this.package, required this.baseUrl});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  void addToCart(Package package) {
    Navigator.pop(context);
    context.read<Restaurant>().addToCart(package);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Image.asset(widget.package.image, height: 400),
                CachedNetworkImage(
                  imageUrl: '${widget.baseUrl}${widget.package.image}',
                  height: 400,
                  placeholder:
                      (context, url) =>
                          Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // food name
                      Text(
                        widget.package.item.toString(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // food price
                      Text(
                        '${widget.package.currency} ${widget.package.price}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),

                      SizedBox(height: 10),

                      // food description
                      Text(widget.package.description.toString()),
                      SizedBox(height: 10),
                      Divider(color: Theme.of(context).colorScheme.primary),
                      SizedBox(height: 10),
                      // addons
                      Text(
                        "Add-ons",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      // button ->  add to the cart
                      PrimaryButton(
                        onPressed: () => addToCart(widget.package),
                        text: "Add to Cart",
                      ),
                      SizedBox(height: 25),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // back button
        SafeArea(
          child: Opacity(
            opacity: 0.6,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.only(left: 25.0),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded),
                onPressed: () => Navigator.pop(context),
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
