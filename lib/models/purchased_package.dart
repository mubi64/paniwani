class PurchasedPackage {
  String? name;
  String? customer;
  String? bottlePackage;
  String? item;
  String? status;
  String? purchaseDate;
  int? bottlesPurchased;
  int? bottlesRemaining;
  String? bottleType;
  String? waterBottleProduct;
  int? bottlesOrdered;

  PurchasedPackage({
    this.name,
    this.customer,
    this.bottlePackage,
    this.item,
    this.status,
    this.purchaseDate,
    this.bottlesPurchased,
    this.bottlesRemaining,
    this.bottleType,
    this.waterBottleProduct,
    this.bottlesOrdered,
  });

  factory PurchasedPackage.fromJson(Map<String, dynamic> json) {
    return PurchasedPackage(
      name: json['name'],
      customer: json['customer'],
      bottlePackage: json['bottle_package'],
      item: json['item'],
      status: json['status'],
      purchaseDate: json['purchase_date'],
      bottlesPurchased: json['bottles_purchased'],
      bottlesRemaining: json['bottles_remaining'],
      bottleType: json['bottle_type'],
      waterBottleProduct: json['water_bottle_product'],
      bottlesOrdered: json['bottles_ordered'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['customer'] = customer;
    data['bottle_package'] = bottlePackage;
    data['item'] = item;
    data['status'] = status;
    data['purchase_date'] = purchaseDate;
    data['bottles_purchased'] = bottlesPurchased;
    data['bottles_remaining'] = bottlesRemaining;
    data['bottle_type'] = bottleType;
    data['water_bottle_product'] = waterBottleProduct;
    data['bottles_ordered'] = bottlesOrdered;
    return data;
  }
}
