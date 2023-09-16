import 'dart:convert';
import 'package:dio/dio.dart';
import '../../models/complaint.dart';

class PhoneService {
  final dio = Dio();
  final String _dataSource = "Cluster0";
  final String _database = "test";
  final String _collection = "complaint";
  final String _endpoint =
      "https://us-east-1.aws.data.mongodb-api.com/app/data-rvnlm/endpoint/data/v1";
  static const _apiKey =
      "0uBZNMNC0voxaeZVDbsHKm1c9R0WPx6DJIKfZSPBxS8aUZK6SxfqxqnYiFjRsqrm";
  var headers = {
    "content-type": "application/json",
    "apiKey": _apiKey,
  };

  Future<List<Complaint>> getPhoneContacts() async {
    var response = await dio.post(
      "$_endpoint/action/find",
      options: Options(headers: headers),
      data: jsonEncode(
        {
          "dataSource": _dataSource,
          "database": _database,
          "collection": _collection,
          "filter": {},
        },
      ),
    );
    if (response.statusCode == 200) {
      var respList = response.data['documents'] as List;
      var phoneList = respList.map((json) => Complaint.fromJson(json)).toList();
      return phoneList;
    } else {
      throw Exception('Error getting phone contacts');
    }
  }

  Future<Complaint> getSinglePhoneContact(String id) async {
    var response = await dio.post(
      "$_endpoint/action/find",
      options: Options(headers: headers),
      data: jsonEncode(
        {
          "dataSource": _dataSource,
          "database": _database,
          "collection": _collection,
          "filter": {
            "_id": {"\$oid": id}
          },
        },
      ),
    );
    if (response.statusCode == 200) {
      var resp = response.data['documents'][0];
      var contact = Complaint.fromJson(resp);
      return contact;
    } else {
      throw Exception('Error getting phone contact');
    }
  }

  Future updatePhoneContact(String id, String fullname, String tanggapan,
      String description, int phonenumber, String validasi) async {
    var response = await dio.post(
      "$_endpoint/action/updateOne",
      options: Options(headers: headers),
      data: jsonEncode(
        {
          "dataSource": _dataSource,
          "database": _database,
          "collection": _collection,
          "filter": {
            "_id": {"\$oid": id}
          },
          "update": {
            "\$set": {
              "fullname": fullname,
              "description": description,
              "phonenumber": phonenumber,
              "tanggapan": tanggapan,
              "validasi": validasi,
            }
          }
        },
      ),
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Error getting phone contact');
    }
  }

  Future createPhoneContact(String fullname, String description,
      String tanggapan, int phonenumber) async {
    var response = await dio.post(
      "$_endpoint/action/insertOne",
      options: Options(headers: headers),
      data: jsonEncode(
        {
          "dataSource": _dataSource,
          "database": _database,
          "collection": _collection,
          "document": {
            "fullname": fullname,
            "description": description,
            "tanggapan": "",
            "phonenumber": phonenumber
          }
        },
      ),
    );
    if (response.statusCode == 201) {
      return response.data;
    } else {
      throw Exception('Error creating phone contact');
    }
  }

  Future deletePhoneContact(String id) async {
    var response = await dio.post(
      "$_endpoint/action/deleteOne",
      options: Options(headers: headers),
      data: jsonEncode(
        {
          "dataSource": _dataSource,
          "database": _database,
          "collection": _collection,
          "filter": {
            "_id": {"\$oid": id}
          },
        },
      ),
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Error deleting phone contact');
    }
  }
}
