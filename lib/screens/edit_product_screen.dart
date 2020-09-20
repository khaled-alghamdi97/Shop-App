import 'package:Shop_App/providers/product_provider.dart';
import 'package:Shop_App/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit-product-screen";
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusedNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _from = GlobalKey<FormState>();

  var isLoading = false;
  var isInit = true;
  var _initialValues = {
    "title": "",
    "description": "",
    "price": "",
    "imageUrl": ""
  };

  var _editedProduct = ProductProvider(
      id: null, title: "", description: "", imageUrl: "", price: 0);

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      var productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findProductById(productId);
        _initialValues = {
          "title": _editedProduct.title,
          "description": _editedProduct.description,
          "price": _editedProduct.price.toString(),
          "imageUrl": ""
        };

        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }

    isInit = false;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    _priceFocusedNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();

    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void sumbitForm() {
    final isValid = _from.currentState.validate();

    if (!isValid) {
      return;
    }
    _from.currentState.save();

    setState(() {
      isLoading = true;
    });

    if (_editedProduct.id != null) {
      Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      Navigator.of(context).pop();
    } else {
      Provider.of<ProductsProvider>(context, listen: false)
          .addNewProduct(_editedProduct)
          .catchError((error) {
        return showDialog<Null>(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("An error Occured!"),
                  content: Text("Ops somthing went wrong!"),
                  actions: [
                    FlatButton(
                      child: Text("Okay"),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    )
                  ],
                ));
      }).then((value) {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: sumbitForm)],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _from,
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _initialValues["title"],
                        decoration: InputDecoration(labelText: "Title"),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) => FocusScope.of(context)
                            .requestFocus(_priceFocusedNode),
                        onSaved: (newValue) {
                          _editedProduct = ProductProvider(
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite,
                              title: newValue,
                              description: "",
                              imageUrl: "",
                              price: 0);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please Enter a Ttile";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initialValues["price"],
                        decoration: InputDecoration(labelText: "price"),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusedNode,
                        onFieldSubmitted: (value) => FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode),
                        onSaved: (newValue) {
                          _editedProduct = ProductProvider(
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite,
                              title: _editedProduct.title,
                              description: "",
                              imageUrl: "",
                              price: double.parse(newValue));
                        },
                        validator: (value) {
                          if (double.tryParse(value) == null) {
                            return "Please enter a valid number";
                          }
                          if (value.isEmpty) {
                            return "Please enter a price";
                          }
                          if (double.parse(value) <= 0) {
                            return "Please enter a value greater thean zero";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initialValues["description"],
                        decoration: InputDecoration(labelText: "description"),
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        focusNode: _descriptionFocusNode,
                        onSaved: (newValue) {
                          _editedProduct = ProductProvider(
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite,
                              title: _editedProduct.title,
                              description: newValue,
                              imageUrl: "",
                              price: _editedProduct.price);
                        },
                        validator: (value) {
                          if (value.length < 10) {
                            return "The descrption is to short. It must have 10 charecter long";
                          }
                          if (value.isEmpty) {
                            return "Please enter a description";
                          }
                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: _imageUrlController.text.isEmpty
                                ? Text("Enter a URL")
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "Image URL",
                              ),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              onSaved: (newValue) {
                                _editedProduct = ProductProvider(
                                    id: _editedProduct.id,
                                    isFavorite: _editedProduct.isFavorite,
                                    title: _editedProduct.title,
                                    description: _editedProduct.description,
                                    imageUrl: newValue,
                                    price: _editedProduct.price);
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please enter an image URL";
                                }
                                if (!value.startsWith("http") &&
                                    !value.startsWith("https")) {
                                  return "Please enter a valid URL";
                                }
                                return null;
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )),
    );
  }
}
