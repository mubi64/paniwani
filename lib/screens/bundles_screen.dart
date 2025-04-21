import 'package:flutter/material.dart';
import '../models/bundle.dart';
import '../services/bundles_service.dart';
import '../utils/strings.dart';
import '../widgets/bundle_card.dart';

class BundlesScreen extends StatefulWidget {
  const BundlesScreen({Key? key}) : super(key: key);

  @override
  State<BundlesScreen> createState() => _BundlesScreenState();
}

class _BundlesScreenState extends State<BundlesScreen> with TickerProviderStateMixin {
  final BundlesService _bundlesService = BundlesService();
  List<Bundle> _availableBundles = [];
  List<Bundle> _activeBundles = [];
  bool _isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadBundles();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBundles() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _activeBundles = await _bundlesService.getActiveBundles();
      _availableBundles = await _bundlesService.getAvailableBundles();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.error)),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.bundles),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Available"),
            Tab(text: "Active"),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                // Available Bundles Tab
                _buildBundleList(_availableBundles, "Buy Now"),
                
                // Active Bundles Tab
                _buildBundleList(_activeBundles, AppStrings.placeOrder),
              ],
            ),
    );
  }

  Widget _buildBundleList(List<Bundle> bundles, String buttonText) {
    if (bundles.isEmpty) {
      return const Center(
        child: Text("No bundles found"),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadBundles,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: bundles.length,
        itemBuilder: (context, index) {
          return BundleCard(
            bundle: bundles[index],
            buttonText: buttonText,
            onPressed: () {
              // Handle action
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Action on ${bundles[index].name}")),
              );
            },
          );
        },
      ),
    );
  }
}