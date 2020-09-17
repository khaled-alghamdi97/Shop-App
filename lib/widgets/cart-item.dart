import 'package:Shop_App/providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  CartItem({this.id, this.price, this.quantity, this.title, this.productId});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 15),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (dismissDirec) {
        Provider.of<Cart>(context, listen: false).deleteItem(productId);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text("Deleting an item"),
                content: Text("Are you sure you want to delete the item"),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                      child: Text("yes")),
                  FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                      child: Text("no"))
                ],
              );
            });
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: FittedBox(child: Text("\$$price")),
            ),
            title: Text(
              title,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            subtitle: Text("Total: \$${price * quantity}"),
            trailing: Text("$quantity x"),
          ),
        ),
      ),
    );
  }
}
