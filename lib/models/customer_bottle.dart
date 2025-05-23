import '../utils/utils.dart';

class CustomerBottle {
  String? name;
  String? waterBottleProduct;
  double? availableQuantity;
  double? companyHand;
  double? customerHand;
  String? bottleType;
  String? item;
  double? price;

  CustomerBottle({
    this.name,
    this.waterBottleProduct,
    this.availableQuantity,
    this.companyHand,
    this.customerHand,
    this.bottleType,
    this.item,
    this.price,
  });

  factory CustomerBottle.fromJson(Map<String, dynamic> json) {
    return CustomerBottle(
      name: json['name'],
      waterBottleProduct: json['water_bottle_product'],
      availableQuantity: Utils().parseDouble(json['available_quantity']),
      companyHand: Utils().parseDouble(json['company_hand']),
      customerHand: Utils().parseDouble(json['customer_hand']),
      bottleType: json['bottle_type'],
      item: json['item'],
      price: Utils().parseDouble(json['price']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['water_bottle_product'] = waterBottleProduct;
    data['available_quantity'] = availableQuantity;
    data['company_hand'] = companyHand;
    data['customer_hand'] = customerHand;
    data['bottle_type'] = bottleType;
    data['item'] = item;
    data['price'] = price;
    return data;
  }
}
