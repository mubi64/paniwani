import 'package.dart';

class CartItem {
  Package package;
  int quantity;

  CartItem({required this.package, this.quantity = 1});
}
