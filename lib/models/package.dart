import '../utils/utils.dart';

class Package {
  String? name;
  String? packageName;
  double? bottleQuantity;
  String? item;
  String? description;
  double? price;
  String? image;
  String? currency;

  Package({
    this.name,
    this.packageName,
    this.bottleQuantity,
    this.item,
    this.description = "",
    this.price,
    this.image,
    this.currency,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      name: json['name'],
      packageName: json['package_name'],
      bottleQuantity: Utils().parseDouble(json['bottle_quantity']),
      item: json['item'],
      description: json['description'] ?? "",
      price: Utils().parseDouble(json['price']),
      image: json['image'],
      currency: json['currency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'package_name': packageName,
      'bottle_quantity': bottleQuantity,
      'item': item,
      'description': description,
      'price': price,
      'image': image,
      'currency': currency,
    };
  }
}
