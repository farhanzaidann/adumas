// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:adumas/core/cache/network.dart';
import 'package:adumas/screens/pages/home.dart';
import 'package:adumas/widgets/error_handler.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../../widgets/my_snackbar.dart';
import '../env.dart';

class AuthService {
  void signUp({
    required BuildContext context,
    required String username,
    required String password,
    required String firstName,
    required String phoneNumber,
    required String level,
    required String nik,
  }) async {
    try {
      var res = await http.post(Uri.parse('$kbApi/auth/register'),
          body: jsonEncode(
            {
              "firstName": firstName,
              "email": "$username@gmail.com",
              "phoneNumber": phoneNumber,
              "password": password,
              "level": level,
            },
          ));

      var datas = jsonDecode(res.body);
      var _id = datas["user"]["_id"];

      var res2 = await mRegister(
          context: context,
          firstName: firstName,
          username: username,
          phoneNumber: phoneNumber,
          nik: nik,
          idU: _id);

      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Berhasil');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future mRegister({
    required BuildContext context,
    required String firstName,
    required String idU,
    required String username,
    required String phoneNumber,
    required String nik,
  }) async {
    try {
      var token = await getSysToken();

      http.Response res = await http.post(Uri.parse('$kbApi/masyarakat'),
          body: jsonEncode({
            "name": firstName,
            "username": username,
            "phoneNumber": phoneNumber,
            "nik": nik,
            "users": [idU]
          }),
          headers: {'Authorization': "Bearer $token"});

      // httpErrorHandler(
      //   response: res,
      //   context: context,
      //   onSuccess: () {
      //     showSnackBar(context, 'Berhasil');
      //   },
      // );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      var token = await getSysToken();

      http.Response res = await http.post(
        Uri.parse('$kbApi/auth/login'),
        body: jsonEncode({
          'email': "$email@gmail.com",
          'password': password,
        }),
      );

      var data = jsonDecode(res.body);

      var level = data["user"]["level"];

      var ids = data["user"]["_id"];

      log(res.body);

      http.Response getUser = await http.get(
          Uri.parse('$kbApi/Users/$ids?\$lookup[*]=*'),
          headers: {"Authorization": "Bearer $token"});

      var datas = jsonDecode(getUser.body);

      httpErrorHandler(
          response: res,
          context: context,
          onSuccess: () async {
            if (data["user"]["level"] == "masyarakat") {
              sessionManager.savePref(
                data["token"],
                data["user"]["_id"],
                datas["masyarakat"][0]["username"],
                datas["masyarakat"][0]["name"],
                datas["masyarakat"][0]["nik"],
                data["user"]["level"],
                data["user"]["phoneNumber"],
              );
            }
            if (data["user"]["level"] == "petugas") {
              sessionManager.savePref(
                data["token"],
                data["user"]["_id"],
                datas["petugas"][0]["username"],
                datas["petugas"][0]["name"],
                datas["petugas"][0]["nik"],
                datas["petugas"][0]["level"],
                data["user"]["phoneNumber"],
              );
            }

            print("stored");

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
