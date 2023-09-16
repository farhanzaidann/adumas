// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:adumas/models/user.dart';
import 'package:adumas/screens/pages/home.dart';
import 'package:adumas/widgets/error_handler.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/my_snackbar.dart';
import '../env.dart';

class AuthService {
  void signUp({
    required BuildContext context,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      User user = User(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Berhasil');
        },
      );
    } catch (e) {
      print(e);
      showSnackBar(context, e.toString());
    }
  }

  void login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/login'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // showSnackBar(context, "${res.statusCode}");
      log(res.statusCode.toString());
      // if (res.statusCode == 400) {
      //   showSnackBar(context, "okeee");
      // }
      httpErrorHandler(
          response: res,
          context: context,
          onSuccess: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('usermail', jsonDecode(res.body)['email']);
            await prefs.setString('lastName', jsonDecode(res.body)['lastName']);
            await prefs.setString(
                'firstName', jsonDecode(res.body)['firstName']);
            Navigator.of(context).pushAndRemoveUntil(
                // ignore: prefer_const_constructors
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (Route route) => false);
          });
    } catch (e) {
      if (e is SocketException) {
        showSnackBar(context, e.toString());
      }
    }
  }
}
