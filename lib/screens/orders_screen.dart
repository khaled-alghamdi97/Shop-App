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
  Future _ordersFuture;

  Future obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchOrders();
  }

  @override
  void initState() {
    _ordersFuture = obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final order = Provider.of<Orders>(context);  if we leave this it will casue infinte loop becasue of future bulider
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Orders"),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
            future: _ordersFuture,
            builder: (ctx, futureData) {
              print(futureData);
              if (futureData.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (futureData.data == null) {
                return Center(
                  child: Text("No order has been placed yet"),
                );
              }
              if (futureData.error != null) {
                return Center(
                  child: Text("error in fetching data"),
                );
              } else {
                return Consumer<Orders>(
                  builder: (context, orderData, child) => ListView.builder(
                    itemBuilder: (context, index) => ord.OrderItem(
                      order: orderData.getOrders[index],
                    ),
                    itemCount: orderData.getOrders.length <= 0
                        ? 0
                        : orderData.getOrders.length,
                  ),
                );
              }
            }));
  }
}
