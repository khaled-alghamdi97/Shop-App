import 'package:Shop_App/screens/edit_product_screen.dart';
import 'package:Shop_App/widgets/user-products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/app-drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = "/user-products";

  Future<void> _fetchOnRefresh(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fecthProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Product"),
          actions: [
            FlatButton(
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
            )
          ],
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _fetchOnRefresh(context),
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: () => _fetchOnRefresh(context),
                      child: Consumer<ProductsProvider>(
                        builder: (context, value, child) => ListView.builder(
                          itemBuilder: (context, index) => Column(
                            children: [
                              UserProducts(
                                id: products.getProducts[index].id,
                                title: products.getProducts[index].title,
                                imageUrl: products.getProducts[index].imageUrl,
                              ),
                              Divider()
                            ],
                          ),
                          itemCount: products.getProducts.length,
                        ),
                      ),
                    ),
        ));
  }
}
