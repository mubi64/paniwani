import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart_item.dart';
import '../models/restaurant.dart';
import '../storage/shared_pref.dart';
import 'quantity_selector.dart';

class MyCartTile extends StatefulWidget {
  final CartItem cartItem;
  const MyCartTile({super.key, required this.cartItem});

  @override
  State<MyCartTile> createState() => _MyCartTileState();
}

class _MyCartTileState extends State<MyCartTile> {
  SharedPref sharedPref = SharedPref();
  String baseUrl = '';

  @override
  void initState() {
    super.initState();
    sharedPref.readString(sharedPref.prefBaseUrl).then((value) {
      setState(() {
        baseUrl = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(
      builder: (context, restaurant, child) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // food image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: '$baseUrl${widget.cartItem.package.image}',
                        fit: BoxFit.cover,
                        height: 100,
                        width: 100,
                        placeholder:
                            (context, url) =>
                                Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // name and price
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.cartItem.package.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${widget.cartItem.package.currency} ${widget.cartItem.package.price}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          SizedBox(height: 10),
                          QuantitySelector(
                            quantity: widget.cartItem.quantity,
                            package: widget.cartItem.package,
                            onIncrement: () {
                              restaurant.addToCart(widget.cartItem.package);
                            },
                            onDecrement: () {
                              restaurant.removeFromCart(widget.cartItem);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
