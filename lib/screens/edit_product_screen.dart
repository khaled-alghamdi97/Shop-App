import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit-product-screen";
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusedNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
      ),
      body: Form(
          child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(15),
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Title"),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) =>
                    FocusScope.of(context).requestFocus(_priceFocusedNode),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "price"),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusedNode,
                onFieldSubmitted: (value) =>
                    FocusScope.of(context).requestFocus(_descriptionFocusNode),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "description"),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                focusNode: _descriptionFocusNode,
              )
            ],
          ),
        ),
      )),
    );
  }
}
