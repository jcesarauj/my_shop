import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget {
  String title;

  AppBarWidget(this.title);

  @override
  AppBar build(BuildContext context) {
    return AppBar(title: Text(title));
  }
}
