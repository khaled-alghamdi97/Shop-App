import 'package:flutter/cupertino.dart';

import 'cart.dart';

class OrderItem {
  final String id;
  final double price;
  final DateTime dateTime;
  final List<CartItem> items;

  OrderItem(
      {@required this.id,
      @required this.price,
      @required this.dateTime,
      @required this.items});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get getOrders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartItems, double amount) {
    var order = OrderItem(
        id: DateTime.now().toString(),
        price: amount,
        dateTime: DateTime.now(),
        items: cartItems);

    _orders.insert(0,
        order); // insted of .add (.insert add to the begining .add to the end);
    notifyListeners();
    print(_orders);
  }
}
