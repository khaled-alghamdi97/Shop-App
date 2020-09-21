import 'package:Shop_App/providers/cart.dart' show Cart;
import 'package:Shop_App/providers/orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/cart-item.dart';

class CartDetail extends StatefulWidget {
  static const routeName = "/cart-detail";

  @override
  _CartDetailState createState() => _CartDetailState();
}

class _CartDetailState extends State<CartDetail> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final order = Provider.of<Orders>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text("Cart"),
        ),
        body: Column(
          children: [
            Card(
              elevation: 5,
              margin: EdgeInsets.all(15),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total"),
                    SizedBox(
                      width: 20,
                    ),
                    Chip(
                      label: Text("\$${cart.getTotalPrice}"),
                    ),
                    Spacer(),
                    isLoading
                        ? CircularProgressIndicator()
                        : FlatButton(
                            onPressed: cart.getItems.length <= 0
                                ? null
                                : () async {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    await order.addOrder(
                                        cart.getItems.values.toList(),
                                        cart.getTotalPrice);
                                    setState(() {
                                      isLoading = false;
                                    });
                                    cart.clearCart();
                                  },
                            child: Text(
                              "Order Now",
                              style: TextStyle(
                                  color: cart.getItems.length <= 0
                                      ? Colors.grey
                                      : Theme.of(context).primaryColor),
                            ))
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
                child: ListView.builder(
              itemBuilder: (ctx, i) => CartItem(
                id: cart.getItems.values.toList()[i].id,
                productId: cart.getItems.keys.toList()[i],
                price: cart.getItems.values.toList()[i].price,
                quantity: cart.getItems.values.toList()[i].quantity,
                title: cart.getItems.values.toList()[i].title,
              ),
              itemCount: cart.getItems.length,
            ))
          ],
        ));
  }
}
