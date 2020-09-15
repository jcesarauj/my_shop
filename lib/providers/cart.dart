import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import './product.dart';

class CartItem {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {@required this.id,
      @required this.productId,
      @required this.title,
      @required this.quantity,
      @required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemsCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
  }

  void AddItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(product.id, (existItem) {
        return CartItem(
            id: existItem.id,
            productId: existItem.productId,
            price: existItem.price,
            quantity: existItem.quantity + 1,
            title: existItem.title);
      });
    } else {
      _items.putIfAbsent(
          product.id,
          () => CartItem(
              id: Random().nextDouble().toString(),
              productId: product.id,
              title: product.title,
              price: product.price,
              quantity: 1));
    }
  }

  void removeProduct(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
