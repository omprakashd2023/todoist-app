import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../common/utils/error_handling.dart';
import '../../../common/utils/utils.dart';

import '../../../models/user.dart';
import '../../../provider/user_provider.dart';
import '../../../routes.dart';

class AuthServices {
  final _url = '${dotenv.env['SERVER_URL']}/user';

  void _onSuccess(http.Response response, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Provider.of<UserProvider>(context, listen: false).setUser(response.body);
    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.homeRoute,
      (route) => false,
    );
    await prefs.setString('x-auth-token', jsonDecode(response.body)['token']);
  }

  //Sign Up User
  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
  }) async {
    User user = User(
      id: '',
      name: name,
      email: email,
      password: password,
    );
    try {
      final uri = Uri.parse('$_url/signup');
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: user.toJson(),
      );

      httpErrorHandle(
        context: context,
        response: response,
        onSuccess: () {
          _onSuccess(response, context);
          showSnackBar(
            context,
            'Account Created Successfully',
          );
        },
      );
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      final uri = Uri.parse('$_url/signin');
      final response = await http.post(
        uri,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print(response.body);
      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(
              context,
              'Logged In Successfully',
            );
            _onSuccess(response, context);
          });
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  void logout({required BuildContext context}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('x-auth-token') ?? '';
      if (token != '') {
        prefs.setString('x-auth-token', '');
      }
      Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.authRoute,
        (route) => false,
      );
      showSnackBar(
        context,
        'Logged Out Successfully',
      );
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  Future<bool> autoLogin({
    required BuildContext context,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('x-auth-token') ?? '';
      if (token == '') {
        prefs.setString('x-auth-token', token);
      }

      final uri = Uri.parse('$_url/verify');
      final response = await http.post(uri, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      });

      if (response.statusCode == 200) {
        final user = jsonDecode(response.body)["user"];
        Provider.of<UserProvider>(context, listen: false).setUser(
          jsonEncode(user),
        );
      }
      return true;
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    return false;
  }
}
