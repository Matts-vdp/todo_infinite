import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todo_infinite/data/PersistedTodos.dart';


class Sync {
  // static const baseUrl = "http://localhost:5000/api/store/";
  static const baseUrl = "https://api.mattsvdp.com/api/store/";

  static Future<FetchResult> fetch(String key) async {
    var uri = baseUrl + key;
    try {
      var response = await http.get(Uri.parse(uri));
      var status = mapStatus(response.statusCode);
      if (status != Status.Success) return FetchResult(null, status);

      var todos = PersistedTodos.fromJson(jsonDecode(response.body), key);
      return FetchResult(todos, status);

    } catch (e) {
      return FetchResult(null, Status.Offline);
    }
  }

  static Future<Status> post(String key, PersistedTodos data) async {
    var uri = baseUrl + key;
    try {
      var response = await http.post(
          Uri.parse(uri),
          body: data.getJson(),
          headers: {"content-type": "application/json"});
      return mapStatus(response.statusCode);

    } catch (e) {
      return Status.Offline;
    }
  }
}

class FetchResult {
  PersistedTodos? data;
  Status status;

  FetchResult(this.data, this.status);
}

Status mapStatus(int code) {
  switch (code) {
    case 200: return Status.Success;
  }
  return Status.Other;
}

enum Status {
  Success,
  Offline,
  Other
}