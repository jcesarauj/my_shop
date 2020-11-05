import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/auth-exception.dart';

class Auth with ChangeNotifier {
  String _userId;
  String _token;
  DateTime _expireDate;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_token != null &&
        _expireDate != null &&
        _expireDate.isAfter(DateTime.now())) {
      return _token;
    } else {
      return null;
    }
  }

  String get userId {
    return isAuth ? _userId : null;
  }

  Future<void> authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCXh6Smh5ALDMHqGuCKFgOT-bmAZ7jiFag';

    final response = await http.post(url,
        body: json.encode({
          "email": email,
          "password": password,
          "returnSecureToken": true,
        }));

    final responseBody = json.decode(response.body);

    if (responseBody["error"] && responseBody["error"] != null) {
      throw AuthException(responseBody["error"]["message"]);
    } else {
      _token = responseBody["idToken"];
      _userId = responseBody["idToken"];
      _expireDate = DateTime.now().add(Duration(
        seconds: int.parse(responseBody["expiresIn"]),
      ));
      notifyListeners();
    }

    return Future.value();
  }

  Future<void> signup(String email, String password) async {
    return authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    return authenticate(email, password, "signInWithPassword");
  }
}
