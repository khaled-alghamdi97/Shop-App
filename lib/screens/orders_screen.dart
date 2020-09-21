import 'package:Shop_App/providers/orders.dart';
import 'package:Shop_App/widgets/app-drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/order-item.dart' as ord;

class OrdersScreen extends StatefulWidget {
  static const routeName = "/orders-screen";

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    Provider.of<Orders>(context, listen: false)
        .fetchOrders()
        .then((value) => null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final order = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Orders"),
        ),
        drawer: AppDrawer(),
        body: ListView.builder(
          itemBuilder: (context, index) => ord.OrderItem(
            order: order.getOrders[index],
          ),
          itemCount: order.getOrders.length <= 0 ? 0 : order.getOrders.length,
        ));
  }
}
