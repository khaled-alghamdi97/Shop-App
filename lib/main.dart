import 'package:Shop_App/providers/product_provider.dart';
import 'package:Shop_App/providers/products_provider.dart';
import 'package:Shop_App/screens/cart_detail.dart';
import 'package:Shop_App/screens/product_detail_screen.dart';
import 'package:Shop_App/screens/products_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Shop_App/providers/cart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ProductsProvider(),
        ),
        ChangeNotifierProvider.value(
            // always use ChangeNotifierProvider.value (casued error).
            value: ProductProvider()),
        ChangeNotifierProvider.value(value: Cart())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: "Lato",
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ProductOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartDetail.routeName: (ctx) => CartDetail()
        },
      ),
    );
  }
}
