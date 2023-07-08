import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:todo_infinite/Data/todoData.dart';

class Sync {
  static Future<TodoData?> fetch() async {
    var uri = "https://localhost:7148/Store/todo";
    var response = await http.get(Uri.parse(uri));
    
    if (response.statusCode != 200) return null;

    return TodoData.fromJson(jsonDecode(response.body));
  }

  static Future<void> post(TodoData data) async {
    var uri = "https://localhost:7148/Store/todo";
    await http.post(
      Uri.parse(uri), 
      body: data.getJson(), 
      headers: {"content-type": "application/json"});
  } 
}