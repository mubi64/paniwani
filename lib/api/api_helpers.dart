// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../storage/shared_pref.dart';
import '../utils/utils.dart';
import 'dio_client.dart';

class APIFunction {
  static const String baseURL = "";
  static const String sentOtp =
      "/api/method/bottled_water_system.api.account.send_otp";
  static const String verifyOtp =
      "/api/method/bottled_water_system.api.account.verify_otp";
  static const String completeRegistration =
      "/api/method/bottled_water_system.api.account.complete_registration_and_login";
  static const String genders =
      "/api/method/bottled_water_system.api.common.get_genders";
  static const String logout =
      "/api/method/bottled_water_system.api.account.logout_user";
  static const String customerInfo =
      "/api/method/bottled_water_system.api.common.get_customer_info";
  static const String addresses =
      "/api/method/bottled_water_system.api.account.get_addresses";
  static const String packages =
      "/api/method/bottled_water_system.api.package.get_packages";
  static const packagePurchase =
      "/api/method/bottled_water_system.api.package.package_purchase";
  static const String purchasedPackages =
      "/api/method/bottled_water_system.api.package.get_customer_package_purchases";
  static const String payment =
      "/api/method/bottled_water_system.api.payment_gateway.make_payment";
  static const String placeOrder =
      "/api/method/bottled_water_system.api.order.place_water_order";
  static const String bottles =
      "/api/method/bottled_water_system.api.package.get_water_bottle_product";
  static const String bottlesPurchase =
      "/api/method/bottled_water_system.api.rent_bottles.rent_water_bottle_product";
  static const String customerWaterBottle =
      "/api/method/bottled_water_system.api.rent_bottles.get_customer_water_bottle";
  static const String createAddress =
      "/api/method/bottled_water_system.api.account.create_address";
  static const String customerOrder =
      "/api/method/bottled_water_system.api.order.get_customer_water_order";

  static Future<dynamic> get(
    BuildContext context,
    Utils? utils,
    String url,
    String? token,
  ) async {
    try {
      SharedPref prefs = SharedPref();
      String baseURL = await prefs.readString(prefs.prefBaseUrl);
      var clientInstance = await DioClient().apiClientInstance(
        context,
        baseURL,
      );
      Response response = await clientInstance.get(url);
      return response.data;
    } catch (e) {
      utils!.loggerPrint(e);
      return null;
    }
  }

  static Future<dynamic> post(
    BuildContext context,
    Utils? utils,
    String url,
    FormData formData,
    String? token,
  ) async {
    try {
      SharedPref prefs = SharedPref();
      String baseURL = await prefs.readString(prefs.prefBaseUrl);
      utils!.loggerPrint(formData);
      var clientInstance = await DioClient().apiClientInstance(
        context,
        baseURL,
      );
      Response response = await clientInstance.post(url, data: formData);
      return response;
    } catch (e) {
      utils!.loggerPrint(e);
      return;
    }
  }

  static Future<dynamic> postJson(
    BuildContext context,
    Utils? utils,
    String url,
    formData,
    String? token,
  ) async {
    try {
      SharedPref prefs = SharedPref();
      String baseURL = await prefs.readString(prefs.prefBaseUrl);
      utils!.loggerPrint(formData);
      var clientInstance = await DioClient().apiClientInstance(
        context,
        baseURL,
      );
      Response response = await clientInstance.post(url, data: formData);
      return response;
    } catch (e) {
      utils!.loggerPrint(e);
      return;
    }
  }

  static Future<dynamic> put(
    BuildContext context,
    Utils? utils,
    String url,
    formData,
    String? token,
  ) async {
    try {
      SharedPref prefs = SharedPref();
      String baseURL = await prefs.readString(prefs.prefBaseUrl);
      utils!.loggerPrint(formData);
      var clientInstance = await DioClient().apiClientInstance(
        context,
        baseURL,
      );
      Response response = await clientInstance.put(url, data: formData);
      return response;
    } catch (e) {
      utils!.loggerPrint(e);
      return;
    }
  }

  static Future<dynamic> delete(
    BuildContext context,
    Utils? utils,
    String url,
    String? token,
  ) async {
    try {
      SharedPref prefs = SharedPref();
      String baseURL = await prefs.readString(prefs.prefBaseUrl);
      var clientInstance = await DioClient().apiClientInstance(
        context,
        baseURL,
      );
      Response response = await clientInstance.delete(url);
      return response.data;
    } catch (e) {
      utils!.loggerPrint(e);
      rethrow;
    }
  }
}
