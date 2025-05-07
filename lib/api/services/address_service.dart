import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../models/address.dart';
import '../../utils/utils.dart';
import '../api_helpers.dart';

class AddressService {
  final Utils utils = Utils();

  Future<List<Address>> getAddresses(BuildContext context) async {
    var response = await APIFunction.get(
      context,
      utils,
      APIFunction.addresses,
      '',
    );
    if (response != null) {
      utils.loggerPrint('Addresses fetched successfully');
      var data = response['message']['addresses'];
      utils.loggerPrint('Data: $data');
      List<Address> addresses = [];
      data.forEach((item) {
        addresses.add(Address.fromJson(item));
      });
      return addresses;
    } else {
      utils.loggerPrint('Failed to fetch addresses: $response');
      return [];
    }
  }

  Future<Address> createAddress(
    BuildContext context,
    String title,
    String detailAddress,
    String city,
    String country,
    String lat,
    String long,
  ) async {
    try {
      var formData = FormData.fromMap({
        "address_title": title,
        "address_type": "Shipping",
        "address_line1": detailAddress,
        "city": city,
        "country": country,
        "latitude": lat,
        "longitude": long,
      });
      var response = await APIFunction.post(
        context,
        utils,
        APIFunction.createAddress,
        formData,
        '',
      );
      if (response != null) {
        utils.loggerPrint('Addresses fetched successfully');
        var data = response.data['message'];
        utils.loggerPrint('Data: $data');
        Address address = Address.fromJson(data);
        return address;
      } else {
        utils.loggerPrint('Failed to fetch addresses: $response');
        return Address();
      }
    } catch (e) {
      utils.loggerPrint('Error in getCustomerBottles: $e');
      return Address();
    }
  }
}
