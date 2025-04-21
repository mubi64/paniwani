import 'package:flutter/material.dart';
import '../models/bundle.dart';
import '../services/auth_service.dart';
import '../services/bundles_service.dart';
import '../utils/strings.dart';
import '../widgets/bundle_card.dart';
import 'bundles_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BundlesService _bundlesService = BundlesService();
  final AuthService _authService = AuthService();
  List<Bundle> _activeBundles = [];
  List<Bundle> _availableBundles = [];
  bool _isLoading = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadBundles();
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
        title: const Text(AppStrings.appName),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildHomeContent(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          
          // Handle navigation
          if (_selectedIndex == 0) {
            // Already on home
          } else if (_selectedIndex == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BundlesScreen()),
            );
          } else if (_selectedIndex == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OrdersScreen()),
            );
          } else if (_selectedIndex == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: AppStrings.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: AppStrings.bundles,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: AppStrings.orders,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: AppStrings.profile,
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return RefreshIndicator(
      onRefresh: _loadBundles,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Card
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello, ${_authService.currentUser?.fullName ?? 'User'}",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _activeBundles.isNotEmpty
                          ? "You have ${_activeBundles.length} active bundle(s)"
                          : "You don't have any active bundles",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Active Bundles Section
            if (_activeBundles.isNotEmpty) ...[
              Text(
                AppStrings.activeBundles,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _activeBundles.length,
                  itemBuilder: (context, index) {
                    return BundleCard(
                      bundle: _activeBundles[index],
                      buttonText: AppStrings.placeOrder,
                      onPressed: () {
                        // Handle place order
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Order placed for ${_activeBundles[index].name}")),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
            
            // Available Bundles Section
            Text(
              AppStrings.availableBundles,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _availableBundles.length,
                itemBuilder: (context, index) {
                  return BundleCard(
                    bundle: _availableBundles[index],
                    buttonText: "Buy Now",
                    onPressed: () {
                      // Handle buy bundle
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Bundle ${_availableBundles[index].name} purchased")),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}