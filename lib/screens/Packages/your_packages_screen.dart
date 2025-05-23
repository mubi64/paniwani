import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:paniwani/utils/strings.dart';
import 'package:provider/provider.dart';

import '../../models/restaurant.dart';
import '../../storage/shared_pref.dart';
import '../../widgets/primary_button.dart';
import '../home_screen.dart';

class YourPackagesScreen extends StatefulWidget {
  const YourPackagesScreen({super.key});

  @override
  State<YourPackagesScreen> createState() => _YourPackagesScreenState();
}

class _YourPackagesScreenState extends State<YourPackagesScreen> {
  SharedPref prefs = SharedPref();
  String? _baseUrl = '';
  @override
  void initState() {
    super.initState();
    getBaseUrl();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  void getBaseUrl() async {
    _baseUrl = await prefs.readString(prefs.prefBaseUrl);
    setState(() {});
  }

  void _fetchData() {
    final restaurant = context.read<Restaurant>();
    restaurant.fetchPurchasedPackages(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${AppStrings.your} ${AppStrings.packages}")),
      body: Consumer<Restaurant>(
        builder: (context, restaurant, child) {
          var actiPackages = restaurant.purchasedPackages;
          var loading = restaurant.isLoadingPPackages;
          if (loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (actiPackages.isEmpty) {
            return Center(
              child: Text(
                "${AppStrings.noPackageFound}...",
                style: TextStyle(fontSize: 18),
              ),
            );
          }
          // returning the list of packages
          return ListView.builder(
            itemCount: actiPackages.length,
            itemBuilder: (context, index) {
              final package = actiPackages[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ActiveProductCard(index: index, package: package),
              );
              //  Container(
              //   width: double.infinity,
              //   decoration: BoxDecoration(
              //     color: Theme.of(context).colorScheme.secondary,
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              //   margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              //   padding: EdgeInsets.all(16.0),
              //   child: Column(
              //     spacing: 8.0,
              //     children: [
              //       // Expanded(
              //       // child: CachedNetworkImage(
              //       //   imageUrl: "${_baseUrl}${package.image}",
              //       //   height: 128,
              //       //   fit: BoxFit.contain,
              //       //   placeholder:
              //       //       (context, url) =>
              //       //           const Center(child: CircularProgressIndicator()),
              //       //   errorWidget: (context, url, error) => const Icon(Icons.error),
              //       // ),
              //       // ),
              //       Container(
              //         height: 128,
              //         decoration: BoxDecoration(
              //           color: Theme.of(context).colorScheme.primary,
              //           borderRadius: BorderRadius.circular(10),
              //         ),
              //       ),
              //       Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         spacing: 4.0,
              //         children: [
              //           Text(
              //             package.item.toString(),
              //             style: TextStyle(
              //               color: Theme.of(context).colorScheme.tertiary,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //           SizedBox(
              //             width: double.infinity,
              //             child: PrimaryButton(
              //               text: AppStrings.order,
              //               onPressed: () {},
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // );
            },
          );
        },
      ),
    );
  }
}
