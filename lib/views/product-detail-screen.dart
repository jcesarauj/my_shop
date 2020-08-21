import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';
import 'package:shop/providers/counter-provider.dart';

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
        children: <Widget>[
          RaisedButton(
              child: Text("+"),
              onPressed: () {
                print(CounterProvider.of(context));
              })
        ],
      ),
    );
  }
}
