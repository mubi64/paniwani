import 'package:flutter/material.dart';
import 'package:paniwani/models/purchased_package.dart';
import 'package:paniwani/utils/strings.dart';
import 'package:provider/provider.dart';

import '../models/package.dart';
import '../models/restaurant.dart';
import '../storage/shared_pref.dart';
import '../widgets/custom_product_card.dart';
import '../widgets/skeleton.dart';
import 'detail_screen.dart';
import 'place_order_screen.dart';

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
  // Placeholder image URLs from Freepik
  final String personDrinkingWaterImage =
      'https://img.freepik.com/free-photo/woman-drinking-water-outdoors_23-2148573429.jpg';

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
    restaurant.fetchPurchasedPackages(context);
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

  void getBaseUrl() async {
    _baseUrl = await prefs.readString(prefs.prefBaseUrl);
    setState(() {});
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                      title: '${AppStrings.active} ${AppStrings.packages}',
                    ),
                    _buildActivePackages(),
                    SectionHeader(title: AppStrings.packages),
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

  Widget _buildActivePackages() {
    return Consumer<Restaurant>(
      builder: (context, restaurant, child) {
        var actiPackages = restaurant.purchasedPackages;
        var loading = restaurant.isLoadingPPackages;
        if (actiPackages.isEmpty) return const SizedBox();
        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 20, bottom: 20),
          child: SizedBox(
            height: 190,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: loading ? 3 : actiPackages.length,
              itemBuilder: (context, index) {
                final package = actiPackages[index];
                if (loading) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Skeleton(height: 300, width: 300, radius: 12),
                  );
                } else {
                  return ActiveProductCard(index: index, package: package);
                }
              },
            ),
          ),
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
    final consumedPercentage =
        (package.bottlesOrdered / package.bottlesRemaining).clamp(0, 1);
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: [
                    index.isEven
                        ? Color(0xFF1D9E83).withValues(alpha: 0.7)
                        : Color(0xFF3AA1CF).withValues(alpha: 0.7),
                    index.isEven
                        ? Color(0xFF1D9E83).withValues(alpha: 0.9)
                        : Color(0xFF3AA1CF).withValues(alpha: 0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 14,
              bottom: 14,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  package.item,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  package.bottleType,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 12,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${package.bottlesRemaining} ${AppStrings.leftbottles}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: IconButton(
                        icon: Icon(
                          color: Theme.of(context).colorScheme.secondary,
                          Icons.playlist_add_rounded,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      PlaceOrderScreen(package: package),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: double.parse(consumedPercentage.toString()),
                        backgroundColor: Colors.white.withValues(alpha: 0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF00CFFF),
                        ),
                        minHeight: 8,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.consumed,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '${(consumedPercentage * 100).toInt()}%',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
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
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
          ),
          itemCount: restaurant.menu.length,
          itemBuilder: (context, index) {
            final product = restaurant.menu[index];
            return CustomProductCard(
              imagePath: '$baseUrl${product.image}',
              price: '${product.currency} ${product.price}',
              productName: product.name,
              onCardTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => DetailScreen(package: product, baseUrl: baseUrl),
                  ),
                );
              },
              onAddPressed: () {
                context.read<Restaurant>().addToCart(product);
              },
            );
          },
        );
      },
    );
  }
}
