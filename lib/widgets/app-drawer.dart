import 'package:Shop_App/providers/auth.dart';
import 'package:Shop_App/screens/orders_screen.dart';
import 'package:Shop_App/screens/user_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text("Navigation"),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed("/");
            },
            leading: Icon(Icons.home),
            title: Text("Home"),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(OrdersScreen.routeName);
            },
            leading: Icon(Icons.shop),
            title: Text("Orders"),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(UserProductsScreen.routeName);
            },
            leading: Icon(Icons.edit),
            title: Text("Manage Products"),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logOut();
            },
            leading: Icon(Icons.exit_to_app),
            title: Text("Log Out"),
          ),
        ],
      ),
    );
  }
}
