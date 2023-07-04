import 'package:flutter/material.dart';

import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User _user = User(
    id: '',
    name: '',
    email: '',
    password: '',
  );

  User get user => _user;

  bool _isAuth = false;
  bool get isAuth => _isAuth;

  void setUser(String user) {
    _user = User.fromJson(user);
    _isAuth = true;
    notifyListeners();
  }
}
