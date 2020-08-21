import 'package:flutter/material.dart';
import 'package:shop/data/dummy-data.dart';
import 'package:shop/models/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = DUMMY_PRODUCTS;

  List<Product> get items => [..._items];

  void AddProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }
}
