import 'package:Shop_App/widgets/products_grit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum FilterOption { Favortie, All }

// ignore: must_be_immutable
class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My shop"),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOption selectedValue) {
              setState(() {
                if (selectedValue == FilterOption.Favortie) {
                  isFavorite = true;
                } else {
                  isFavorite = false;
                }
                print(isFavorite);
              });
            },
            icon: Icon(Icons.toc),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("show Favorite"),
                value: FilterOption.Favortie,
              ),
              PopupMenuItem(
                child: Text("show All"),
                value: FilterOption.All,
              )
            ],
          )
        ],
      ),
      body: ProductsGrid(isFavorite),
    );
  }
}
