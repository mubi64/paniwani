import 'package:paniwani/utils/utils.dart';

class CustomerOrder {
  String? name;
  String? customer;
  double? bottleQuantity;
  double? deliveredQuantity;
  double? outstandingQuantity;
  String? consumedFrom;
  String? item;
  String? status;
  String? orderDate;
  String? deliveryDate;
  String? bottleType;
  String? address;

  CustomerOrder({
    this.name,
    this.customer,
    this.bottleQuantity,
    this.deliveredQuantity,
    this.outstandingQuantity,
    this.consumedFrom,
    this.item,
    this.status,
    this.orderDate,
    this.deliveryDate,
    this.bottleType,
    this.address,
  });

  factory CustomerOrder.fromJson(Map<String, dynamic> json) {
    return CustomerOrder(
      name: json['name'],
      customer: json['customer'],
      bottleQuantity: Utils().parseDouble(json['bottle_quantity']),
      deliveredQuantity: Utils().parseDouble(json['delivered_quantity']),
      outstandingQuantity: Utils().parseDouble(json['outstanding_quantity']),
      consumedFrom: json['consumed_from'],
      item: json['item'],
      status: json['status'],
      orderDate: json['order_date'],
      deliveryDate: json['delivery_date'],
      bottleType: json['bottle_type'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['customer'] = customer;
    data['bottle_quantity'] = bottleQuantity;
    data['delivered_quantity'] = deliveredQuantity;
    data['outstanding_quantity'] = outstandingQuantity;
    data['consumed_from'] = consumedFrom;
    data['item'] = item;
    data['status'] = status;
    data['order_date'] = orderDate;
    data['delivery_date'] = deliveryDate;
    data['bottle_type'] = bottleType;
    data['address'] = address;
    return data;
  }
}
