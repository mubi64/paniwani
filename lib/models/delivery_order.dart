class DeliveryOrder {
  String? name;
  String? waterBottleProduct;
  String? customer;
  int? bottleQuantity;
  int? deliveredQuantity;
  int? outstandingQuantity;
  String? item;
  String? bottleType;
  String? status;
  String? orderDate;
  String? deliveryDate;
  String? address;
  String? latitude;
  String? longitude;

  DeliveryOrder({
    this.name,
    this.waterBottleProduct,
    this.customer,
    this.bottleQuantity,
    this.deliveredQuantity,
    this.outstandingQuantity,
    this.item,
    this.bottleType,
    this.status,
    this.orderDate,
    this.deliveryDate,
    this.address,
    this.latitude,
    this.longitude,
  });

  DeliveryOrder.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    waterBottleProduct = json['water_bottle_product'];
    customer = json['customer'];
    bottleQuantity = json['bottle_quantity'];
    deliveredQuantity = json['delivered_quantity'];
    outstandingQuantity = json['outstanding_quantity'];
    item = json['item'];
    bottleType = json['bottle_type'];
    status = json['status'];
    orderDate = json['order_date'];
    deliveryDate = json['delivery_date'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['water_bottle_product'] = waterBottleProduct;
    data['customer'] = customer;
    data['bottle_quantity'] = bottleQuantity;
    data['delivered_quantity'] = deliveredQuantity;
    data['outstanding_quantity'] = outstandingQuantity;
    data['item'] = item;
    data['bottle_type'] = bottleType;
    data['status'] = status;
    data['order_date'] = orderDate;
    data['delivery_date'] = deliveryDate;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
