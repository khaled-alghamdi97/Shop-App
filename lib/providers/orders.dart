import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  Future<void> fetchOrders() async {
    var url =
        "https://flutter-testing-37474.firebaseio.com/orders/$userId/.json/?auth=$authToken";

    List<OrderItem> ordersHolder = [];

    final response = await http.get(url);
    if (response == null) {
      return;
    }
    var extarctedData = json.decode(response.body) as Map<String, dynamic>;

    extarctedData.forEach((orderId, orderData) {
      ordersHolder.add(OrderItem(
          id: orderId,
          price: orderData['price'],
          dateTime: DateTime.parse(orderData['dateTime']),
          items: (orderData['items'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title']))
              .toList()));
    });

    _orders = ordersHolder;
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartItems, double amount) async {
    var url =
        "https://flutter-testing-37474.firebaseio.com/orders/$userId/.json?auth=$authToken";
    var order = OrderItem(
        id: DateTime.now().toString(),
        price: amount,
        dateTime: DateTime.now(),
        items: cartItems);

    final response = await http.post(url,
        body: json.encode({
          "price": order.price,
          "dateTime": order.dateTime.toString(),
          "items": cartItems
              .map((e) => {
                    "id": e.id,
                    "title": e.title,
                    "price": e.price,
                    "quantity": e.quantity
                  })
              .toList()
        }));

    print(response.statusCode);

    _orders.insert(0,
        order); // insted of .add (.insert add to the begining .add to the end);
    notifyListeners();
    print(_orders);
  }
}
