// LOCAL IP TO CONNECT ON MONGODB

import 'package:dio/dio.dart';

String uri = 'http://192.168.1.7:5000';
String mdApi = 'https://us-east-1.aws.data.mongodb-api.com/app/data-rvnlm/endpoint/data/v1';

// KONTENBASE API

String kbApi = 'https://api.kontenbase.com/query/api/v1/a9fc3e08-8fce-458b-9b8a-7b8b5330ed0f';

Future<String> getSysToken() async {
  Dio dio = Dio();
  try {
    Response res = await dio.post("$kbApi/auth/login",
        data: {"email": "token@token.token", "password": "2wsx1qaz"});
    if (res.statusCode == 200) {
      return res.data["token"];
    }
  } catch (e) {
    print("error token $e");
    return "ERROR";
  }
  return "ERROR";
}