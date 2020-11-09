import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/views/auth-screen.dart';
import 'package:shop/views/products-overview-screen.dart';

class AuthOrHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);
    return FutureBuilder(
        future: auth.tryAutoLogin(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return auth.isAuth ? ProductsOverviewScreen() : AuthScreen();
          }
        });
  }
}
