import 'package:flutter/material.dart';
import 'package:shop/providers/product.dart';

class ProductDetailScreen extends StatelessWidget {
  ProductDetailScreen();

  @override
  Widget build(BuildContext context) {
    final Product _product =
        ModalRoute.of(context).settings.arguments as Product;
    return Scaffold(
      appBar: AppBar(
        title: Text(_product.title),
      ),
      body: Column(
        children: <Widget>[RaisedButton(child: Text("+"), onPressed: () {})],
      ),
    );
  }
}
