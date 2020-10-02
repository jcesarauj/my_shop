import 'dart:math';

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
    _items.add(Product(
      id: Random().nextDouble().toString(),
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
    ));
    notifyListeners();
  }

  void UpdateProduct(Product product) {
    if (product == null || product.id == null) {
      return;
    }

    final index = _items.indexWhere((prod) => prod.id != product.id);

    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
  }
}
