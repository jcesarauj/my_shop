import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop/utils/constants.dart';
import 'cart.dart';

class Order {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime date;

  Order({this.id, this.total, this.products, this.date});
}

class Orders with ChangeNotifier {
  final String _baseUrl = '${Constants.BASE_API_URL}orders';
  String _token;

  List<Order> _items = [];

  Orders([this._token, this._items = const []]);

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadOrders() async {
    List<Order> loadedItens = [];
    final response = await http.get("$_baseUrl.json?auth=$_token");
    Map<String, dynamic> data = json.decode(response.body);
    _items.clear();
    if (data != null) {
      data.forEach((orderId, orderData) {
        loadedItens.add(
          Order(
              id: orderId,
              total: orderData['total'],
              date: DateTime.parse(orderData['date']),
              products: (orderData['products'] as List<dynamic>).map((item) {
                return CartItem(
                  id: item['id'],
                  title: item['title'],
                  price: item['price'],
                  quantity: item['quantity'],
                  productId: item['productId'],
                );
              }).toList()),
        );
      });
      notifyListeners();
    }
    _items = loadedItens.reversed.toList();
    return Future.value();
  }

  Future<void> addOrder(List<CartItem> products, double total) async {
    DateTime dateTime = DateTime.now();

    final response = await http.post("$_baseUrl.json?auth=$_token",
        body: json.encode({
          'total': total,
          'date': dateTime.toIso8601String(),
          'products': products
              .map((cartItem) => {
                    'id': cartItem.id,
                    'productId': cartItem.productId,
                    'title': cartItem.title,
                    'quantity': cartItem.quantity,
                    'price': cartItem.price
                  })
              .toList(),
        }));

    _items.insert(
        0,
        Order(
            id: json.decode(response.body)["name"],
            total: total,
            date: dateTime,
            products: products));

    notifyListeners();
  }
}
