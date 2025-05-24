import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:paniwani/models/purchased_package.dart';

import '../../models/customer_bottle.dart';
import '../../models/customer_order.dart';
import '../../models/package.dart';
import '../../utils/utils.dart';
import '../api_helpers.dart';

class PackageService {
  final Utils utils = Utils();

  Future<List<Package>> getPackages(BuildContext context) async {
    try {
      var response = await APIFunction.get(
        context,
        utils,
        APIFunction.packages,
        '',
      );
      if (response != null) {
        utils.loggerPrint('Packages fetched successfully');
        var data = response['message'];
        utils.loggerPrint('Data: $data');
        List<Package> packages = [];
        data.forEach((item) {
          packages.add(Package.fromJson(item));
        });
        return packages;
      } else {
        utils.loggerPrint('Failed to fetch packages: $response');
        return [];
      }
    } catch (e) {
      utils.loggerPrint('Error in getPackages: $e');
      return [];
    }
  }

  Future<String> purchasePackage(BuildContext context, List packages) async {
    try {
      var formData = {'bottle_packages': packages};
      var response = await APIFunction.postJson(
        context,
        utils,
        APIFunction.packagePurchase,
        formData,
        '',
      );
      if (response != null) {
        utils.loggerPrint('Package purchased successfully');
        utils.loggerPrint('Response: ${response.data}');
        utils.loggerPrint('Payment made successfully');
        return response.data['message']['sales_invoice'];
      } else {
        utils.loggerPrint('Failed to purchase package: $response');
        return '';
      }
    } catch (e) {
      utils.loggerPrint('Error in purchasePackage: $e');
      return '';
    }
  }

  Future<String> purchaseBottles(BuildContext context, List bottles) async {
    try {
      var response = await APIFunction.postJson(
        context,
        utils,
        APIFunction.bottlesPurchase,
        {"customer_water_bottle": bottles},
        '',
      );
      if (response != null) {
        utils.loggerPrint('Bottle purchased successfully');
        return 'Bottle purchased successfully';
      } else {
        utils.loggerPrint('Failed to purchase package: $response');
        return '';
      }
    } catch (e) {
      utils.loggerPrint('Error in bottle purchase: $e');
      return '';
    }
  }

  Future<dynamic> makePayment(
    BuildContext context,
    String cardNumber,
    String expMonth,
    String expYear,
    String cvc,
    int isBottleRent,
    String? invoice,
    List? waterBottles,
  ) async {
    try {
      var formData = {
        "card_number": cardNumber,
        "exp_month": expMonth,
        "exp_year": expYear,
        "cvc": cvc,
        "is_bottle_rent": isBottleRent,
        "sales_invoice": invoice,
        "customer_water_bottle": waterBottles,
      };
      var response = await APIFunction.postJson(
        context,
        utils,
        APIFunction.payment,
        formData,
        '',
      );
      if (response != null) {
        return response.data;
      }
    } catch (e) {
      utils.loggerPrint('Error in makePayment 146: $e');
      return e;
    }
  }

  Future<List<PurchasedPackage>> getPurchasedPackages(
    BuildContext context,
  ) async {
    try {
      var response = await APIFunction.get(
        context,
        utils,
        APIFunction.purchasedPackages,
        '',
      );
      if (response != null) {
        utils.loggerPrint('Purchased packages fetched successfully');
        var data = response['message'];
        List<PurchasedPackage> purchasedPackages = [];
        data.forEach((item) {
          purchasedPackages.add(PurchasedPackage.fromJson(item));
        });
        return purchasedPackages;
      } else {
        utils.loggerPrint('Failed to fetch purchased packages: $response');
        return [];
      }
    } catch (e) {
      utils.loggerPrint('Error in getPurchasedPackages: $e');
      return [];
    }
  }

  Future<void> placeOrder(
    BuildContext context,
    String package,
    int qty,
    String ddate,
    String address,
  ) async {
    try {
      var formData = FormData.fromMap({
        "package_name": package,
        "bottle_quantity": qty,
        "delivery_date": ddate,
        "address": address,
      });
      var response = await APIFunction.post(
        context,
        utils,
        APIFunction.placeOrder,
        formData,
        '',
      );
      if (response != null) {
        utils.loggerPrint('Order placed successfully');
        return response.data['message'];
      } else {
        utils.loggerPrint('Failed to place order: $response');
        return;
      }
    } catch (e) {
      utils.loggerPrint('Error in placeOrder: $e');
    }
  }

  // customerWaterBottle
  Future<List<CustomerBottle>> getCustomerBottles(BuildContext context) async {
    try {
      var response = await APIFunction.get(
        context,
        utils,
        APIFunction.customerWaterBottle,
        '',
      );
      if (response != null) {
        var data = response['message'];
        List<CustomerBottle> cutomerBottles = [];
        data.forEach((item) {
          cutomerBottles.add(CustomerBottle.fromJson(item));
        });
        return cutomerBottles;
      } else {
        utils.loggerPrint('Failed to fetch customer bottles: $response');
        return [];
      }
    } catch (e) {
      utils.loggerPrint('Error in getCustomerBottles: $e');
      return [];
    }
  }

  // Customer Order
  Future<List<CustomerOrder>> getCustomerOrders(BuildContext context) async {
    try {
      var response = await APIFunction.get(
        context,
        utils,
        APIFunction.customerOrder,
        '',
      );
      if (response != null) {
        var data = response['message'];
        List<CustomerOrder> customerOrder = [];
        data.forEach((item) {
          customerOrder.add(CustomerOrder.fromJson(item));
        });
        return customerOrder;
      } else {
        utils.loggerPrint('Failed to fetch customer bottles: $response');
        return [];
      }
    } catch (e) {
      utils.loggerPrint('Error in getCustomerBottles: $e');
      return [];
    }
  }

  // securety return
  Future<void> returnBottles(
    BuildContext context,
    String bottleId,
    int qty,
  ) async {
    try {
      var formData = {"water_bottle_product": bottleId, "quantity": qty};
      var response = await APIFunction.postJson(
        context,
        utils,
        APIFunction.securityReturn,
        formData,
        '',
      );
      if (response != null) {
        utils.loggerPrint('Bottle returned successfully');
        utils.showToast('Bottle returned successfully', context);
        return;
      } else {
        utils.loggerPrint('Failed to return bottle: $response');
        utils.showToast('Failed to return bottle', context);
        return;
      }
    } catch (e) {
      utils.loggerPrint('Error in returnBottles: $e');
    }
  }
}
