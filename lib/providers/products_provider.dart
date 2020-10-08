import 'package:Shop_App/model/http_delete_exiption.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'product_provider.dart';

class ProductsProvider with ChangeNotifier {
  List<ProductProvider> _products = [
    // ProductProvider(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // ProductProvider(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // ProductProvider(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // ProductProvider(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  final String authToken;

  ProductsProvider(this.authToken, this._products);

  List<ProductProvider> get getProducts {
    return [..._products];
  }

  List<ProductProvider> get getFilterdProducts {
    return _products.where((element) => element.isFavorite).toList();
  }

  ProductProvider findProductById(String id) {
    return getProducts.firstWhere((element) => element.id == id);
  }

  Future<void> fecthProduct() async {
    final url =
        "https://flutter-testing-37474.firebaseio.com/products/.json?auth=$authToken";
    try {
      final response = await http.get(url);
      var extractedData = json.decode(response.body) as Map<String, dynamic>;

      List<ProductProvider> loadedProducts = [];
      extractedData.forEach((key, value) {
        loadedProducts.add(ProductProvider(
            id: key,
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl'],
            title: value['title'],
            isFavorite: value['isFavorite']));
      });
      _products = loadedProducts;
    } catch (error) {
      print("catch block in fetchProduct()");
      print(error);
    }
  }

  Future<void> addNewProduct(ProductProvider product) {
    final url =
        "https://flutter-testing-37474.firebaseio.com/products/.json?auth=$authToken";
    return http
        .post(url,
            body: json.encode({
              "title": product.title,
              "description": product.description,
              "price": product.price,
              "imageUrl": product.imageUrl,
              "isFavorite": product.isFavorite
            }))
        .then((response) {
      print(json.decode(response.body)["name"]);
      var newProduct = ProductProvider(
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price,
          id: json.decode(response.body)["name"]);

      _products.add(newProduct);
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> updateProduct(String id, ProductProvider product) async {
    final url =
        "https://flutter-testing-37474.firebaseio.com/products/$id/.json";
    await http.patch(url,
        body: json.encode({
          "title": product.title,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl
        }));

    var productIndex = _products.indexWhere((element) => element.id == id);

    _products[productIndex] = product;
    notifyListeners();
  }

  Future<void> removeProduct(String id) async {
    var existingProductIndex =
        _products.indexWhere((element) => element.id == id);
    var existsingProduct = _products[existingProductIndex];

    final url =
        "https://flutter-testing-37474.firebaseio.com/products/$id/.json/";
    _products.removeAt(existingProductIndex);
    notifyListeners();
    final respone = await http.delete(url);

    if (respone.statusCode >= 400) {
      _products.insert(existingProductIndex, existsingProduct);
      notifyListeners();
      throw HttpExeption("delete has been failed");
    }

    existsingProduct = null;
  }
}
