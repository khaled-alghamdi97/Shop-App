import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders.dart' as ord;

class OrderItem extends StatelessWidget {
  final ord.OrderItem order;

  const OrderItem({this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        child: ListTile(
          title: Text(
            order.price.toString(),
            style: TextStyle(fontSize: 20),
          ),
          subtitle: Text(
            DateFormat.yMEd().format(order.dateTime).toString(),
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
          trailing: IconButton(
            onPressed: null,
            icon: Icon(Icons.expand_more),
          ),
        ));
  }
}
