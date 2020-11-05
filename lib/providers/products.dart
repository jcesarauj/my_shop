import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/providers/product.dart';
import 'package:shop/utils/constants.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  List<Product> get items => [..._items];
  final String _baseUrl = '${Constants.BASE_API_URL}products';
  String _token = "";
  String _userId = "";

  Products([this._token, this._userId, this._items = const []]);

  int get itemsCount {
    return _items.length;
  }

  List<Product> get favoriteItems {
    return items.where((prod) => prod.isFavorite).toList();
  }

  Future<void> loadProducts() async {
    final response = await http.get("$_baseUrl.json?auth=$_token");
    final favoriteResponse = await http.get(
        "${Constants.BASE_API_URL}/userFavorites/$_userId.json?auth=$_token");
    final favoriteMap = json.decode(favoriteResponse.body);

    Map<String, dynamic> data = json.decode(response.body);
    _items.clear();
    if (data != null) {
      data.forEach((productId, productData) {
        final isFavorite =
            favoriteMap == null ? false : favoriteMap[productId] ?? false;
        _items.add(
          Product(
              id: productId,
              title: productData['title'],
              description: productData['description'],
              price: productData['price'],
              imageUrl: productData['imageUrl'],
              isFavorite: isFavorite),
        );
      });
      notifyListeners();
    }
    return Future.value();
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      "$_baseUrl.json?auth=$_token",
      body: json.encode({
        "title": product.title,
        "description": product.description,
        "price": product.price,
        "imageUrl": product.imageUrl,
        "isFavorite": product.isFavorite
      }),
    );

    _items.add(Product(
        id: json.decode(response.body)["name"],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl));

    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    if (product == null || product.id == null) {
      return;
    }

    final index = _items.indexWhere((prod) => prod.id != product.id);

    if (index >= 0) {
      await http.patch(
        "$_baseUrl/${product.id}.json?auth=$_token",
        body: {
          "title": product.title,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl
        },
      );

      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final index = _items.indexWhere((product) => product.id == id);
    if (index >= 0) {
      final product = _items[index];
      await http.delete(
        "$_baseUrl/${product.id}.json?auth=$_token",
      );

      _items.remove(product);
      notifyListeners();
    }
  }
}
