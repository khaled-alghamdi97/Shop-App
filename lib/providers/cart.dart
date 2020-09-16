import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.price,
      @required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> items = {};

  Map<String, CartItem> get getItems {
    return items;
  }

  int get itemsCount {
    return items.length;
  }

  double get getTotalPrice {
    var total = 0.0;
    items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void addItem(String productId, String title, double price) {
    if (items.containsKey(productId)) {
      items.update(
          productId,
          (existingCartItem) => CartItem(
              id: productId,
              title: title,
              price: price,
              quantity: existingCartItem.quantity + 1));
    } else {
      items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              price: price,
              title: title,
              quantity: 1));
    }
    notifyListeners();
  }

  void deleteItem(String productId) {
    items.remove(productId);
    notifyListeners();
  }
}
