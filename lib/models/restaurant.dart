import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:paniwani/api/services/auth_service.dart';
import 'package:paniwani/models/address.dart';
import 'package:paniwani/models/customer_bottle.dart';
import '../api/services/address_service.dart';
import '../api/services/package_service.dart';
import 'cart_item.dart';
import 'customer_order.dart';
import 'package.dart';
import 'purchased_package.dart';

class Restaurant extends ChangeNotifier {
  List<Package> _menu = [];
  /* G E T T E R S */
  List<Package> get menu => _menu;
  List<CartItem> get cart => _cart;

  // Fetch packages from API
  Future<void> fetchMenu(BuildContext context) async {
    try {
      // Call your API service to fetch packages
      List<Package> fetchedPackages = await PackageService().getPackages(
        context,
      );
      _menu.clear();
      _menu = fetchedPackages;
      notifyListeners();
    } catch (e) {
      // Handle any errors that occur during the API call
      print("Error fetching packages: $e");
    }
  }

  /* O P E R A T I O N S */
  // User Cart
  final List<CartItem> _cart = [];

  // Add to cart
  void addToCart(Package package) {
    // check if food is already in cart
    CartItem? cartItem = _cart.firstWhereOrNull((item) {
      bool isSameFood = item.package == package;
      return isSameFood;
    });
    // if it is, increase quantity
    if (cartItem != null) {
      cartItem.quantity++;
    } else {
      // if not, add to cart
      _cart.add(CartItem(package: package));
    }
    // if not, add to cart
    notifyListeners();
  }

  // remove from cart
  void removeFromCart(CartItem cartItem) {
    int cartIndex = _cart.indexOf(cartItem);
    if (cartIndex != -1) {
      if (cartItem.quantity > 1) {
        cartItem.quantity--;
      } else {
        _cart.removeAt(cartIndex);
      }
      notifyListeners();
    }
  }

  // get total price of cart
  double getTotalPrice() {
    double total = 0.0;
    for (CartItem cartItem in _cart) {
      double itemTotal = cartItem.package.price;

      total += itemTotal * cartItem.quantity;
    }
    return total;
  }

  // get total price with currency... currency is in package
  String getTotalPriceWithCurrency() {
    double total = getTotalPrice();
    String currency = _cart.isNotEmpty ? _cart[0].package.currency : '';
    return "$currency ${total.toStringAsFixed(2)}";
  }

  // get total number of items in cart
  int getTotalItemCount() {
    int total = 0;
    for (CartItem cartItem in _cart) {
      total += cartItem.quantity;
    }
    return total;
  }

  // clear cart
  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  /* H E L P E R S */
  // generate a receipt
  String displayCartReceipt() {
    final receipt = StringBuffer();
    receipt.writeln("Here's your receipt.");
    receipt.writeln();

    // formate the date to include up to seconds only
    String formattedDate = DateFormat(
      "yyyy-MM-dd HH:mm:ss",
    ).format(DateTime.now());

    receipt.writeln(formattedDate);
    receipt.writeln();
    receipt.writeln("----------");

    for (final cartItem in _cart) {
      receipt.writeln(
        "${cartItem.quantity} x ${cartItem.package.name} - ${_formatePrice(cartItem.package.price)}",
      );
      receipt.writeln();
    }
    receipt.writeln("----------");
    receipt.writeln();
    receipt.writeln("Total Items: ${getTotalItemCount()}");
    receipt.writeln("Total Price: ${_formatePrice(getTotalPrice())}");

    return receipt.toString();
  }

  // formate double value into money
  String _formatePrice(double price) {
    return "\$${price.toStringAsFixed(2)}";
  }

  /* P A R C H A S E D   P A C K A G E S */
  List<PurchasedPackage> _purchasedPackages = [];
  List<PurchasedPackage> get purchasedPackages => _purchasedPackages;
  bool _isLoadingPPackages = true;
  bool get isLoadingPPackages => _isLoadingPPackages;
  Future<void> fetchPurchasedPackages(BuildContext context) async {
    try {
      _isLoadingPPackages = true;
      notifyListeners();
      List<PurchasedPackage> packages = await PackageService()
          .getPurchasedPackages(context);
      _purchasedPackages = packages;
      notifyListeners();
      _isLoadingPPackages = false;
      notifyListeners();
    } catch (e) {
      _isLoadingPPackages = false;
      print("Error fetching purchased packages: $e");
    }
  }

  /* A D D R E S S E S */
  Address? _shippingAddress;
  Address? get shippingAddress => _shippingAddress;
  Future<void> getShippingAddress(BuildContext context) async {
    try {
      List<Address> addresses = await AddressService().getAddresses(context);
      // Find the address with isShippingAddress == 1
      _shippingAddress = addresses.firstWhereOrNull(
        (address) => address.isShippingAddress == 1,
      );
      _shippingAddress ??= addresses.isNotEmpty ? addresses.first : null;
      notifyListeners();
    } catch (e) {
      print("Error fetching shipping address: $e");
    }
  }

  /* G E N D E R S */
  List<String> _genders = [];
  List<String> get genders => _genders;

  Future<void> fetchGenders(BuildContext context) async {
    _genders = await AuthService().getGenders(context);
    notifyListeners();
  }

  List<CustomerBottle> _customerBottles = [];
  List<CustomerBottle> get customerBottles => _customerBottles;
  Future<void> fetchCustomerBottles(BuildContext context) async {
    _customerBottles = await PackageService().getCustomerBottles(context);
    notifyListeners();
  }

  /* CUSTOMER ORDERS */
  List<CustomerOrder> _customerOrders = [];
  List<CustomerOrder> get customerOrders => _customerOrders;
  bool isLoadingCustomerOrder = true;
  Future<void> fetchCustomerOrders(BuildContext context) async {
    isLoadingCustomerOrder = true;
    notifyListeners();
    _customerOrders = await PackageService().getCustomerOrders(context);
    notifyListeners();
    isLoadingCustomerOrder = false;
    notifyListeners();
  }

  Future<void> orderPlace(
    BuildContext context,
    String package,
    int qty,
    String ddate,
    String address,
  ) async {
    await PackageService().placeOrder(context, package, qty, ddate, address);
    await fetchPurchasedPackages(context);
    notifyListeners();
  }
}
