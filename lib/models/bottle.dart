import '../utils/utils.dart';

class Bottle {
  String? name;
  String? bottleType;
  String? item;
  double? price;

  Bottle({this.name, this.bottleType, this.item, this.price});

  Bottle.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    bottleType = json['bottle_type'];
    item = json['item'];
    price = Utils().parseDouble(json['price']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['bottle_type'] = bottleType;
    data['item'] = item;
    data['price'] = price;
    return data;
  }
}
