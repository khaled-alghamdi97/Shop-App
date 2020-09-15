import 'package:Shop_App/providers/products_provider.dart';
import 'package:Shop_App/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;
  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final providerObject = Provider.of<ProductsProvider>(context);
    final products = showFavs
        ? providerObject.getFilterdProducts
        : providerObject.getProducts;

    return GridView.builder(
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 3 / 2,
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: (ctx, i) {
          return Padding(
            padding: const EdgeInsets.all(5),
            child: ChangeNotifierProvider.value(
              // always use ChangeNotifierProvider.value (casued error).
              value: products[i],
              child: ProductItem(
                  // id: products[i].id,
                  // imageUrl: products[i].imageUrl,
                  // price: products[i].price,
                  // title: products[i].title,
                  ),
            ),
          );
        });
  }
}
