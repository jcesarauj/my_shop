import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/utils/app-routes.dart';
import 'package:shop/views/auth-home.dart';
import 'package:shop/views/auth-screen.dart';
import 'package:shop/views/cart-screen.dart';
import 'package:shop/views/orders-screen.dart';
import 'package:shop/views/product-form-screen.dart';
import 'package:shop/views/products-screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => new Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => new Products(null, null, []),
          update: (ctx, auth, previousProducts) =>
              new Products(auth.token, auth.userId, previousProducts.items),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => new Orders(),
          update: (ctx, auth, previousProducts) =>
              new Orders(auth.token, auth.userId, previousProducts.items),
        ),
        ChangeNotifierProvider(
          create: (_) => new Cart(),
        ),
      ],
      child: MaterialApp(
        title: 'Minha Loja',
        theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato'),
        home: AuthScreen(),
        routes: {
          AppRoutes.HOME: (ctx) => AuthOrHome(),
          AppRoutes.CART: (ctx) => CartScreen(),
          AppRoutes.ORDERS: (ctx) => OrdersScreen(),
          AppRoutes.PRODUCTS: (ctx) => ProductsScreen(),
          AppRoutes.PRODUCT_FORM: (ctx) => ProductFormScreen()
        },
      ),
    );
  }
}
