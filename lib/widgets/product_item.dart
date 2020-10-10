import 'package:Shop_App/providers/auth.dart';
import 'package:Shop_App/providers/cart.dart';
import 'package:Shop_App/providers/product_provider.dart';
import 'package:Shop_App/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  // final double price;

  // const ProductItem({this.id, this.title, this.imageUrl, this.price});

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context, listen: false);
    final loadedProduct = Provider.of<ProductProvider>(context, listen: false);
    final cart = Provider.of<Cart>(context);
    print("it rebulds");
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
              arguments: loadedProduct.id);
        },
        child: GridTile(
          child: Image.network(
            loadedProduct.imageUrl,
            fit: BoxFit.cover,
          ),
          footer: GridTileBar(
            title: Text(
              loadedProduct.title,
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.black87,
            leading: Consumer<ProductProvider>(
                // the consumer is alternative of provider.of so we dont rebuild the whole widget just a part of it
                builder: (context, value, child) => IconButton(
                      icon: value.isFavorite
                          ? Icon(Icons.star)
                          : Icon(Icons.star_border),
                      color: Theme.of(context).accentColor,
                      onPressed: () async {
                        try {
                          await value.toggleFavoriteValue(
                              authData.token, authData.userId);
                        } catch (err) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("change favorite is failed")));
                        }
                      },
                    )),
            trailing: IconButton(
                icon: Icon(Icons.shopping_cart),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  cart.addItem(loadedProduct.id, loadedProduct.title,
                      loadedProduct.price);
                  Scaffold.of(context).showSnackBar(SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text("added to the cart!"),
                    action: SnackBarAction(
                      label: "UNDO",
                      onPressed: () {
                        cart.removeSingleItem(loadedProduct.id);
                      },
                    ),
                  ));
                }),
          ),
        ),
      ),
    );
  }
}
