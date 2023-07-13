import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:todo_infinite/data/PersistedTodos.dart';

import 'todoData.dart';


class Sync {
  // static const baseUrl = "http://localhost:5000/api/store/";
  static const baseUrl = "https://api.mattsvdp.com/api/store/";

  static Future<PersistedTodos?> fetch(String key) async {
    var uri = baseUrl + key;
    var response = await http.get(Uri.parse(uri));
    debugPrint(response.statusCode.toString());
    if (response.statusCode != 200) return null;

    return PersistedTodos.fromJson(jsonDecode(response.body));
  }

  static Future<bool> post(String key, PersistedTodos data) async {
    var uri = baseUrl + key;
    var response = await http.post(
      Uri.parse(uri), 
      body: data.getJson(), 
      headers: {"content-type": "application/json"});
    debugPrint(response.statusCode.toString());
    return response.statusCode == 200;
  } 
}