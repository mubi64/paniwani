import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paniwani/models/purchased_package.dart';
import 'package:paniwani/screens/Packages/package_screen.dart';
import 'package:paniwani/screens/bottle_rent_screen.dart';
import 'package:paniwani/utils/strings.dart';
import 'package:paniwani/widgets/primary_button.dart';
import 'package:provider/provider.dart';

import '../models/restaurant.dart';
import '../storage/shared_pref.dart';
import '../widgets/custom_product_card.dart';
import '../widgets/promotional_banner.dart';
import '../widgets/skeleton.dart';
import 'detail_screen.dart';
import 'navigation_bar_screen.dart';
import 'place_order_screen.dart';
import 'Packages/your_packages_screen.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
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
    restaurant.getCurrentUser(context);
    restaurant.fetchMenu(context);
    restaurant.fetchPurchasedPackages(context);
    restaurant.fetchCustomerOrders(context);
  }

  void getBaseUrl() async {
    _baseUrl = await prefs.readString(prefs.prefBaseUrl);
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _fetchData(); // Re-fetch when returning
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PromotionalBanner(),
                    _buildActivePackages(),
                    _buildQuickActions(),
                    _buildRecentOrders(),
                    ProductGrid(baseUrl: _baseUrl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        SizedBox(height: 8),
        SectionHeader(title: AppStrings.quickActions),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            spacing: 14,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              QuickActionButton(
                text: AppStrings.orderWater,
                onPressed: () {},
                icon: Icons.shopping_cart,
              ),
              QuickActionButton(
                text: AppStrings.rentBottle,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BottleRentScreen()),
                  );
                },
                icon: Icons.water_drop,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivePackages() {
    return Consumer<Restaurant>(
      builder: (context, restaurant, child) {
        var actiPackages = restaurant.purchasedPackages;
        var loading = restaurant.isLoadingPPackages;
        if (actiPackages.isEmpty) {
          return Container();
        }
        // return Padding(
        //   padding: const EdgeInsets.only(left: 10, right: 20, bottom: 20),
        //   child: SizedBox(
        //     height: 100,
        //     child: ListView.builder(
        //       scrollDirection: Axis.horizontal,
        //       padding: const EdgeInsets.symmetric(horizontal: 8),
        //       itemCount: loading ? 3 : actiPackages.length,
        //       itemBuilder: (context, index) {
        //       },
        //     ),
        //   ),
        // );

        final package = actiPackages[0];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: '${AppStrings.your} ${AppStrings.packages}',
              isViewAll: true,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => YourPackagesScreen()),
                );
              },
            ),
            loading
                ? Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Skeleton(height: 100, width: 300, radius: 10),
                )
                : ActiveProductCard(index: 0, package: package),
          ],
        );
      },
    );
  }

  Widget _buildRecentOrders() {
    return Consumer<Restaurant>(
      builder: (context, restaurant, child) {
        var orders = restaurant.customerOrders;
        var loading = restaurant.isLoadingCustomerOrder;
        if (orders.isEmpty) {
          return Container();
        }

        return Column(
          children: [
            SectionHeader(
              title: AppStrings.recentOrders,
              isViewAll: true,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NavigationBarScreen(initialIndex: 1),
                  ),
                );
              },
            ),
            loading
                ? Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Skeleton(height: 100, width: 300, radius: 12),
                )
                : SizedBox(
                  height: 90,
                  child: ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return Container(
                        padding: EdgeInsets.all(16),
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${AppStrings.order} #${order.name}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  Text(
                                    DateFormat('MMM dd, yyyy')
                                        .format(
                                          DateTime.parse(
                                            order.deliveryDate.toString(),
                                          ),
                                        )
                                        .toString(),
                                    style: TextStyle(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.tertiaryFixedDim,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(order.status.toString()),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
          ],
        );
      },
    );
  }
}

class ActiveProductCard extends StatelessWidget {
  ActiveProductCard({super.key, required this.index, required this.package});

  final PurchasedPackage package;
  int index;

  @override
  Widget build(BuildContext context) {
    final consumedPercentage = ((package.bottlesOrdered ?? 0) /
            (package.bottlesRemaining ?? 0))
        .clamp(0, 1);
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        spacing: 16,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: 8,
            children: [
              Container(
                color: Colors.white,
                height: 50,
                width: 50,
                child: Icon(
                  Icons.water_drop,
                  color: Theme.of(context).colorScheme.primary,
                  size: 50,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    package.item.toString(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    package.bottleType.toString(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiaryFixedDim,
                      fontSize: 12,
                    ),
                  ),
                  Row(
                    spacing: 8,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: 80,
                          child: LinearProgressIndicator(
                            value: double.parse(consumedPercentage.toString()),
                            backgroundColor:
                                Theme.of(context).colorScheme.surface,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF00CFFF),
                            ),
                            minHeight: 8,
                          ),
                        ),
                      ),
                      Text(
                        "${package.bottlesOrdered} ${AppStrings.bottles}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiaryFixedDim,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          PrimaryButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlaceOrderScreen(package: package),
                ),
              );
            },
            text: AppStrings.order,
          ),
        ],
      ),
    );
    // return Container(
    //   width: 300,
    //   margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
    //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
    //   child: Stack(
    //     children: [
    //       Positioned.fill(
    //         child: Container(
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(15),
    //             gradient: LinearGradient(
    //               colors: [
    //                 index.isEven
    //                     ? Color(0xFF1D9E83).withValues(alpha: 0.7)
    //                     : Color(0xFF3AA1CF).withValues(alpha: 0.7),
    //                 index.isEven
    //                     ? Color(0xFF1D9E83).withValues(alpha: 0.9)
    //                     : Color(0xFF3AA1CF).withValues(alpha: 0.9),
    //               ],
    //               begin: Alignment.topLeft,
    //               end: Alignment.bottomRight,
    //             ),
    //           ),
    //         ),
    //       ),
    //       Container(
    //         padding: const EdgeInsets.only(
    //           left: 20,
    //           right: 20,
    //           top: 14,
    //           bottom: 14,
    //         ),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text(
    //               package.item.toString(),
    //               overflow: TextOverflow.ellipsis,
    //               maxLines: 1,
    //               style: TextStyle(
    //                 color: Theme.of(context).colorScheme.secondary,
    //                 fontSize: 22,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //             Text(
    //               package.bottleType.toString(),
    //               style: TextStyle(
    //                 color: Theme.of(context).colorScheme.secondary,
    //                 fontSize: 12,
    //               ),
    //             ),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     Text(
    //                       '${package.bottlesRemaining} ${AppStrings.leftbottles}',
    //                       style: TextStyle(
    //                         color: Theme.of(context).colorScheme.secondary,
    //                         fontSize: 16,
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //                 Container(
    //                   margin: EdgeInsets.only(bottom: 4),
    //                   decoration: BoxDecoration(
    //                     color: Theme.of(context).colorScheme.inversePrimary,
    //                     borderRadius: BorderRadius.circular(100),
    //                   ),
    //                   child: IconButton(
    //                     icon: Icon(
    //                       color: Theme.of(context).colorScheme.secondary,
    //                       Icons.playlist_add_rounded,
    //                     ),
    //                     onPressed: () {
    //                       Navigator.push(
    //                         context,
    //                         MaterialPageRoute(
    //                           builder:
    //                               (context) =>
    //                                   PlaceOrderScreen(package: package),
    //                         ),
    //                       );
    //                     },
    //                   ),
    //                 ),
    //               ],
    //             ),
    //             Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 ClipRRect(
    //                   borderRadius: BorderRadius.circular(10),
    //                   child: LinearProgressIndicator(
    //                     value: double.parse(consumedPercentage.toString()),
    //                     backgroundColor: Colors.white.withValues(alpha: 0.3),
    //                     valueColor: AlwaysStoppedAnimation<Color>(
    //                       Color(0xFF00CFFF),
    //                     ),
    //                     minHeight: 8,
    //                   ),
    //                 ),
    //                 SizedBox(height: 8),
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Text(
    //                       AppStrings.consumed,
    //                       style: TextStyle(
    //                         color: Theme.of(context).colorScheme.secondary,
    //                         fontSize: 12,
    //                       ),
    //                     ),
    //                     Text(
    //                       '${(consumedPercentage * 100).toInt()}%',
    //                       style: TextStyle(
    //                         color: Colors.white,
    //                         fontSize: 12,
    //                         fontWeight: FontWeight.bold,
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final bool isViewAll;
  final VoidCallback? onPressed;

  const SectionHeader({
    super.key,
    required this.title,
    this.isViewAll = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          if (isViewAll)
            TextButton(
              onPressed: onPressed,
              child: Text(
                AppStrings.viewAll,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}

class ProductGrid extends StatelessWidget {
  final String baseUrl;
  const ProductGrid({super.key, required this.baseUrl});

  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(
      builder: (context, restaurant, _) {
        if (restaurant.menu.isEmpty) {
          return Center(
            child: Text(
              AppStrings.noProductsAvailable,
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontSize: 16,
              ),
            ),
          );
        }
        return Column(
          children: [
            SectionHeader(
              title: AppStrings.packages,
              isViewAll: true,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PackageScreen()),
                );
              },
            ),
            Container(
              height: 280,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: restaurant.menu.length,
                itemBuilder: (context, index) {
                  final product = restaurant.menu[index];
                  return CustomProductCard(
                    imagePath: '$baseUrl${product.image}',
                    price: '${product.currency} ${product.price}',
                    productName: product.item.toString(),
                    onCardTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => DetailScreen(
                                package: product,
                                baseUrl: baseUrl,
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
            ),
          ],
        );
      },
    );
  }
}

class QuickActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData icon;
  const QuickActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent.withOpacity(0.5),
                ),
                padding: EdgeInsets.all(16),
                child: Icon(icon, size: 32, color: Colors.white),
              ),
              SizedBox(height: 12),
              Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
