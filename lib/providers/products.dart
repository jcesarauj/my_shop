import 'package:flutter/material.dart';
import 'package:shop/data/dummy-data.dart';
import 'package:shop/providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = DUMMY_PRODUCTS;

  List<Product> get items => [..._items];

  int get itemsCount {
    return _items.length;
  }

  List<Product> get favoriteItems {
    return items.where((prod) => prod.isFavorite).toList();
  }

  void AddProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }
}
