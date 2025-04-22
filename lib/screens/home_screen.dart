import 'package:flutter/material.dart';
import 'package:paniwani/screens/orders_screen.dart';
import 'package:paniwani/screens/profile_screen.dart';


class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Order tab selected by default

  // Placeholder image URLs from Freepik
  final List<String> bottleImages = [
    'assets/images/19_litre_bottle.png'
  ];

  final String personDrinkingWaterImage = 'https://img.freepik.com/free-photo/woman-drinking-water-outdoors_23-2148573429.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildActivePackages(),
                    _buildOrderHeader(),
                    _buildProductGrid(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  
  Widget _buildActivePackages() {
    List<Map<String, dynamic>> activePackages = [
      {
        'name': '100 Bottles',
        'remaining': '20 bottles left',
        'nextDelivery': 'Next delivery: Tomorrow',
        'progress': 0.8,
        'image': personDrinkingWaterImage,
      },
      {
        'name': '10 Bottles',
        'remaining': '10 bottles left',
        'nextDelivery': 'Next delivery: Friday',
        'progress': 0,
        'image': personDrinkingWaterImage,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Active Packages',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Container(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: activePackages.length,
                itemBuilder: (context, index) {
                  final package = activePackages[index];
                  return Container(
                    width: 300,
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: NetworkImage(package['image']),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          index % 2 == 0
                              ? Color(0xFF1D9E83).withValues(alpha: 0.8)
                              : Color(0xFF3AA1CF).withValues(alpha: 0.8),
                          BlendMode.overlay,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                colors: [
                                  index % 2 == 0
                                      ? Color(0xFF1D9E83).withValues(alpha: 0.7)
                                      : Color(0xFF3AA1CF).withValues(alpha: 0.7),
                                  index % 2 == 0
                                      ? Color(0xFF1D9E83).withValues(alpha: 0.9)
                                      : Color(0xFF3AA1CF).withValues(alpha: 0.9),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                package['name'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                package['remaining'],
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),
                              // Text(
                              //   package['nextDelivery'],
                              //   style: TextStyle(
                              //     color: Colors.white.withValues(alpha: 0.9),
                              //     fontSize: 14,
                              //   ),
                              // ),
                              SizedBox(height: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: LinearProgressIndicator(
                                      value: package['progress'],
                                      backgroundColor: Colors.white.withValues(alpha: 0.3),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                      minHeight: 8,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Consumed',
                                        style: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.9),
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        '${(package['progress'] * 100).toInt()}%',
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        'Packages',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    List<Map<String, dynamic>> products = [
      {
        'name': '100 Bottles',
        'price': 'PKR 8000',
        'image': bottleImages[0],
      },
      {
        'name': '50 Bottles',
        'price': 'PKR 4500',
        'image': bottleImages[0],
      },
      {
        'name': '10 Bottles',
        'price': 'PKR 1000',
        'image': bottleImages[0],
      },
      {
        'name': '5 Bottles',
        'price': 'PKR 600',
        'image': bottleImages[0],
      },
    ];

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
      itemCount: products.length,
      itemBuilder: (context, index) {
        return _buildProductItem(products[index]);
      },
    );
  }

  Widget _buildProductItem(Map<String, dynamic> product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  product['image'],
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1D9E83),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product['price'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: const EdgeInsets.only(right: 10, bottom: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF1D9E83),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.add, color: Colors.white, size: 18),
                onPressed: () {},
                constraints: BoxConstraints.tight(Size(28, 28)),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

}