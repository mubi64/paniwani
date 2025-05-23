import 'package:flutter/material.dart';
import 'package:paniwani/utils/utils.dart';

import '../../models/delivery_order.dart';
import '../api_helpers.dart';

class DeliveryOrderService {
  Utils utils = Utils();

  Future<List<DeliveryOrder>> getDeliveryOrders(BuildContext context) async {
    try {
      var response = await APIFunction.get(
        context,
        utils,
        APIFunction.deliveryOrders,
        '',
      );
      if (response != null) {
        utils.loggerPrint('Delivery orders fetched successfully');
        var data = response['message'];
        utils.loggerPrint('Data: $data');
        List<DeliveryOrder> deliveryOrders = [];
        data.forEach((item) {
          deliveryOrders.add(DeliveryOrder.fromJson(item));
        });
        return deliveryOrders;
      } else {
        utils.loggerPrint('Failed to fetch delivery orders: $response');
        return [];
      }
    } catch (e) {
      utils.loggerPrint('Error in getDeliveryOrders: $e');
      return [];
    }
  }

  Future<List<DeliveryOrder>> getCompleteOrders(BuildContext context) async {
    try {
      var response = await APIFunction.get(
        context,
        utils,
        APIFunction.completeOrders,
        '',
      );
      if (response != null) {
        utils.loggerPrint('Delivery orders fetched successfully');
        var data = response['message'];
        utils.loggerPrint('Data: $data');
        List<DeliveryOrder> deliveryOrders = [];
        data.forEach((item) {
          deliveryOrders.add(DeliveryOrder.fromJson(item));
        });
        return deliveryOrders;
      } else {
        utils.loggerPrint('Failed to fetch delivery orders: $response');
        return [];
      }
    } catch (e) {
      utils.loggerPrint('Error in getDeliveryOrders: $e');
      return [];
    }
  }

  Future<void> updateDeliveryOrder(
    BuildContext context,
    String name,
    int qty,
  ) async {
    try {
      var formData = {'water_order': name, 'delivered_quantity': qty};
      var response = await APIFunction.postJson(
        context,
        utils,
        APIFunction.updateDeliveryOrder,
        formData,
        '',
      );
      if (response != null) {
        utils.loggerPrint('Delivery order updated successfully');
        utils.loggerPrint('Response: ${response.data}');
        utils.showToast('Delivery order updated successfully', context);
      } else {
        utils.loggerPrint('Failed to update delivery order: $response');
        utils.showToast('Failed to update delivery order', context);
      }
    } catch (e) {
      utils.loggerPrint('Error in updateDeliveryOrder: $e');
      utils.showToast('Error in updating delivery order', context);
    }
  }

  Future<void> bottleReturn(
    BuildContext context,
    String customer,
    String waterOrder,
    String waterBottleProduct,
    int qty,
  ) async {
    try {
      var formData = {
        "customer": customer,
        "water_order": waterOrder,
        "water_bottle_product": waterBottleProduct,
        "quantity": qty,
      };
      var response = await APIFunction.postJson(
        context,
        utils,
        APIFunction.bottleReturn,
        formData,
        '',
      );
      if (response != null) {
        utils.loggerPrint('Bottle return updated successfully');
        utils.loggerPrint('Response: ${response.data}');
        utils.showToast('Bottle return updated successfully', context);
      } else {
        utils.loggerPrint('Failed to update bottle return: $response');
        utils.showToast('Failed to update bottle return', context);
      }
    } catch (e) {
      utils.loggerPrint('Error in bottleReturn: $e');
      utils.showToast('Error in updating bottle return', context);
    }
  }
}
