import 'dart:convert';

import 'package:todo_infinite/data/todoData.dart';

import 'file.dart';

class PersistedTodos {
  DateTime lastMod;
  TodoData data;

  PersistedTodos(this.lastMod, this.data);

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
  factory PersistedTodos.fromJson(Map<String, dynamic> parsedJson) {
    return PersistedTodos(
        DateTime.parse(parsedJson["lastMod"]),
        TodoData.fromJson(parsedJson["data"])
    );
  }

  void save() {
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
}