import '../models/bundle.dart';

class BundlesService {
  Future<List<Bundle>> getActiveBundles() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      Bundle(
        id: "b1",
        name: "Basic Water Supply",
        description: "10 liters per day",
        price: 599.0,
        isActive: true,
      ),
      Bundle(
        id: "b2",
        name: "Premium Water Supply",
        description: "20 liters per day",
        price: 999.0,
        isActive: true,
      ),
    ];
  }

  Future<List<Bundle>> getAvailableBundles() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      Bundle(
        id: "b3",
        name: "Standard Water Supply",
        description: "15 liters per day",
        price: 799.0,
      ),
      Bundle(
        id: "b4",
        name: "Economy Water Supply",
        description: "5 liters per day",
        price: 399.0,
      ),
      Bundle(
        id: "b5",
        name: "Deluxe Water Supply",
        description: "25 liters per day",
        price: 1299.0,
      ),
    ];
  }
}