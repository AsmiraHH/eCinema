import 'dart:async';
import 'dart:convert';
import 'package:ecinema_admin/models/paged_result.dart';
import 'package:http/http.dart' as http;
import 'package:ecinema_admin/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

abstract class BaseProvider<T> with ChangeNotifier {
  late String _baseUrl;
  late String _endpoint;

  String get baseUrl => _baseUrl;
  String get endpoint => _endpoint;

  BaseProvider(String endpoint) {
    _baseUrl = const String.fromEnvironment("baseUrl", defaultValue: "http://localhost:7019/");
    _endpoint = endpoint;
  }

  Map<String, String> createHeaders() {
    String username = Authorization.username ?? "";
    String password = Authorization.password ?? "";

    String auth = "Basic ${base64Encode(utf8.encode('$username:$password'))}";

    var headers = {"Content-Type": "application/json", "Authorization": auth};

    return headers;
  }

  Future<List<T>> getAll() async {
    var url = "$_baseUrl$_endpoint/GetAll";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var req = await http.get(uri, headers: headers);
    if (isValidResponse(req)) {
      List<T> result = [];
      var data = jsonDecode(req.body);
      for (var item in data) {
        result.add(fromJson(item));
      }
      return result;
    } else {
      throw Exception("Error");
    }
  }

  Future<PagedResult<T>> getPaged(dynamic params) async {
    var queryString = getQueryString(params);
    var url = "$_baseUrl$_endpoint/GetPaged?$queryString";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var req = await http.get(uri, headers: headers);
    if (isValidResponse(req)) {
      var result = PagedResult<T>();
      var data = jsonDecode(req.body);
      result.pageCount = data['pageCount'];
      result.totalCount = data['totalCount'];
      result.hasNextPage = data['hasNextPage'];
      result.hasPreviousPage = data['hasPreviousPage'];
      for (var item in data['listOfItems']) {
        result.items.add(fromJson(item));
      }
      return result;
    } else {
      throw Exception("Error");
    }
  }

  Future<T> insert(dynamic object) async {
    var url = "$_baseUrl$_endpoint/Post";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var obj = jsonEncode(object);
    var response = await http.post(uri, headers: headers, body: obj);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception('Error...');
    }
  }

  Future<T> update(dynamic object) async {
    var url = "$_baseUrl$_endpoint/Put";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var obj = jsonEncode(object);
    var response = await http.put(uri, headers: headers, body: obj);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception('Error...');
    }
  }

  Future<bool> delete(int id) async {
    var url = "$_baseUrl$_endpoint/Delete/$id";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.delete(uri, headers: headers);

    if (!isValidResponse(response)) {
      throw Exception('Error...');
    }

    return true;
  }

  T fromJson(data) {
    throw Exception("Not implemented fromJson method");
  }

  String getQueryString(Map params, {bool inRecursion = false}) {
    String query = '';
    params.forEach((key, value) {
      if (inRecursion) {
        if (key is int) {
          key = '[$key]';
        } else if (value is List || value is Map) {
          key = '.$key';
        } else {
          key = '.$key';
        }
      }
      if (value is String || value is int || value is double || value is bool) {
        var encoded = value;
        if (value is String) {
          encoded = Uri.encodeComponent(value);
        }
        if (query.isNotEmpty) {
          query += '&';
        }
        query += '$key=$encoded';
      } else if (value is DateTime) {
        if (query.isNotEmpty) {
          query += '&';
        }
        query += '$key=${(value).toIso8601String()}';
      } else if (value is List || value is Map) {
        if (value is List) value = value.asMap();
        value.forEach((k, v) {
          query += getQueryString({k: v}, inRecursion: true);
        });
      }
    });
    return query;
  }

  bool isValidResponse(Response response) {
    if (response.statusCode <= 299) {
      return true;
    } else if (response.statusCode == 401 ||
        response.body.contains('UserWrongCredentialsException') ||
        response.body.contains('UserNotFoundException')) {
      throw Exception("Wrong credentials.");
    } else if (response.statusCode == 403) {
      throw Exception("Unauthorized access.");
    } else {
      dynamic message = "Undefined error";
      Map<String, dynamic> error = jsonDecode(response.body);
      if (error.containsKey('errors')) {
        message = error['error']['ERROR'][0];
      }
      throw Exception(message);
    }
  }
}
