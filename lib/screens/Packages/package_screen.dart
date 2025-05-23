import 'package:flutter/material.dart';
import 'package:paniwani/utils/strings.dart';
import 'package:provider/provider.dart';

import '../../models/restaurant.dart';
import '../../storage/shared_pref.dart';
import '../../widgets/custom_product_card.dart';
import '../detail_screen.dart';
import '../home_screen.dart';

class PackageScreen extends StatefulWidget {
  const PackageScreen({super.key});

  @override
  State<PackageScreen> createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {
  SharedPref prefs = SharedPref();
  String _baseUrl = '';

  @override
  void initState() {
    super.initState();
    getBaseUrl();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  void _fetchData() {
    final restaurant = context.read<Restaurant>();
    restaurant.fetchMenu(context);
  }

  void getBaseUrl() async {
    _baseUrl = await prefs.readString(prefs.prefBaseUrl);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.packages)),
      body: Consumer<Restaurant>(
        builder: (context, restaurant, child) {
          var menu = restaurant.menu;

          if (menu.isEmpty) {
            return Center(
              child: Text(
                AppStrings.noPackageFound,
                style: TextStyle(fontSize: 18),
              ),
            );
          }
          // returning the list of packages
          return Center(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: menu.length,
              itemBuilder: (context, index) {
                final product = menu[index];
                return CustomProductCard(
                  imagePath: '$_baseUrl${product.image}',
                  price: '${product.currency} ${product.price}',
                  productName: product.item.toString(),
                  onCardTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => DetailScreen(
                              package: product,
                              baseUrl: _baseUrl,
                            ),
                      ),
                    );
                  },
                  onAddPressed: () {
                    context.read<Restaurant>().addToCart(product);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
