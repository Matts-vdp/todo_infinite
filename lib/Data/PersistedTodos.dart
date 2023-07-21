import 'dart:convert';
import 'package:flutter/material.dart';

import '../data/todoData.dart';
import 'file.dart';

class PersistedTodos {
  DateTime lastMod;
  TodoData data;
  String key;

  PersistedTodos(this.lastMod, this.data, this.key);

  // used to convert the object to json
  Map<String, dynamic> toJson() {
    Map? todo = data.toJson();

    return {
      'lastMod': lastMod.toIso8601String(),
      'data': todo,
    };
  }

  String getJson() {
    return jsonEncode(this.toJson());
  }

  // used to create a TodoData object from a json string
  factory PersistedTodos.fromJson(Map<String, dynamic> parsedJson, String key) {
    debugPrint(DateTime.parse(parsedJson["lastMod"]).toString());
    return PersistedTodos(
        DateTime.parse(parsedJson["lastMod"]),
        TodoData.fromJson(parsedJson["data"]),
        key
    );
  }

  void save() {
    lastMod = DateTime.now();
    writeFile(this.getJson(), "data.json");
  }

  void changeName(List<int> arr, String name) {
    data.changeName(arr, name);
    save();
  }

  void toggleDone(List<int> arr) {
    data.toggleDone(arr);
    save();
  }

  void toggleOpen(List<int> arr) {
    data.toggleOpen(arr);
  }

  getTodo(List<int> arr) {
    return data.getTodo(arr);
  }

  void addTodo(List<int> arr, String str) {
    data.addTodo(arr, str);
    save();
  }

  void delTodo(List<int> arr) {
    data.delTodo(arr);
    save();
  }

  void moveTo(List<int> from, List<int> to) {
    data.moveTo(from, to);
    save();
  }

  void reorder(List<int> arr, int oldid, int newid) {
    data.reorder(arr, oldid, newid);
    save();
  }

  int compareLastMod(PersistedTodos other){
    return lastMod.compareTo(other.lastMod);
  }
}

Future<PersistedTodos> readTodosFromFile(String key) async {
  var str = await readFile("data.json");
  if (str.isEmpty) return PersistedTodos(DateTime(0), TodoData("To Do"), "key");
  return PersistedTodos.fromJson(jsonDecode(str), key);
}