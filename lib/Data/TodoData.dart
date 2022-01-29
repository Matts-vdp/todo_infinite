import 'package:get/get.dart';
import 'dart:convert';
import '../file.dart';
import 'package:flutter/material.dart';

// represends a todo item
class TodoData {
  String text;
  bool done = false;
  bool open = false;
  List<TodoData> sub = <TodoData>[];

  TodoData(this.text);

  // used to get a todo from within this
  TodoData getTodo(List<int> arr) {
    List<int> a = List<int>.from(arr);
    if (a.isEmpty) {
      return this;
    }
    int i = a.first;
    a.removeAt(0);
    return this.sub[i].getTodo(a);
  }

  void toggleDone(List<int> arr) {
    TodoData t = getTodo(arr);
    t.done = !t.done;
  }

  void toggleOpen(List<int> arr) {
    TodoData t = getTodo(arr);
    t.open = !t.open;
  }

  void addTodo(List<int> arr, String str) {
    getTodo(arr).sub.add(new TodoData(str));
  }

  void addTodoData(List<int> arr, TodoData todo) {
    getTodo(arr).sub.add(todo);
  }

  void delTodo(List<int> arr) {
    List<int> a = List<int>.from(arr);
    var i = a.last;
    a.removeLast();
    getTodo(a).sub.removeAt(i);
  }

  void moveTo(List<int> item, List<int> target) {
    TodoData sel = getTodo(item);
    addTodoData(target, sel);
    delTodo(item);
  }

  //Creates a todo with the given data
  TodoData newData(bool donei, List<TodoData> subi) {
    this.done = donei;
    this.sub = subi;
    return this;
  }

  void reorder(List<int> arr, int oldid, int newid) {
    print(oldid);
    print(newid);
    if (oldid < newid) {
      newid -= 1;
    }
    TodoData sel = getTodo(arr);
    final TodoData item = sel.sub.removeAt(oldid);
    sel.sub.insert(newid, item);
  }

  // used to convert the object to json
  Map toJson() {
    List<Map>? subs = this.sub.map((i) => i.toJson()).toList();

    return {
      'text': this.text,
      'done': this.done,
      'sub': subs,
    };
  }

  String getJson() {
    return jsonEncode(this);
  }

  // used to create a TodoData object from a json string
  factory TodoData.fromJson(Map<String, dynamic> parsedJson) {
    List<dynamic> l = parsedJson['sub'];
    List<TodoData> s = <TodoData>[];
    for (int i = 0; i < l.length; i++) {
      s.add(TodoData.fromJson(l[i]));
    }
    return TodoData(parsedJson['text']).newData(
      parsedJson['done'],
      s,
    );
  }

  void save() {
    writeFile(this.getJson(), "data.json");
  }
}

class Settings {
  int cnt = 0;
  int color = 0;
  
  Settings(int i, int c){
    cnt = i;
    color = c;
  }

  static const List<MaterialColor> colors = [
    Colors.purple,
    Colors.pink,
    Colors.blue,
    Colors.cyan,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.orange,
    Colors.red,
  ];
  // used to convert the object to json
  Map toJson() {
    return {
      'cnt': this.cnt,
      'color': this.color,
    };
  }

  String getJson() {
    return jsonEncode(this);
  }

  // used to create a object from a json string
  factory Settings.fromJson(Map<String, dynamic> parsedJson) {
    return Settings(parsedJson["cnt"], parsedJson["color"]);
  }

  void save() {
    writeFile(this.getJson(), "settings.json");
  }
}

// is used to control the state management of the App
class Controller extends GetxController {
  TodoData todo = TodoData("To Do");
  Settings settings = Settings(0, 2);
  Controller(String td, String sett) {
    if (td.isNotEmpty) { 
      todo = TodoData.fromJson(jsonDecode(td));
    }
    if (sett.isNotEmpty) { 
      settings = Settings.fromJson(jsonDecode(sett));
    }
  }

  void toggleDone(List<int> arr) {
    todo.toggleDone(arr);
    update();
    todo.save(); // save to local storage when changed
  }

  void toggleOpen(List<int> arr) {
    todo.toggleOpen(arr);
    update();
  }

  String getText(List<int> arr) {
    return todo.getTodo(arr).text;
  }

  bool getOpen(List<int> arr) {
    return todo.getTodo(arr).open;
  }

  TodoData getTodo(List<int> arr) {
    return todo.getTodo(arr);
  }

  bool getDone(List<int> arr) {
    return todo.getTodo(arr).done;
  }

  void addTodo(List<int> arr, String str) {
    todo.addTodo(arr, str);
    update();
    todo.save(); // save to local storage when changed
  }

  void delTodo(List<int> arr) {
    update();
    todo.delTodo(arr);
    todo.save(); // save to local storage when changed
  }

  void moveTodo(List<int> from, List<int> to){
    todo.moveTo(from, to);
    update();
    todo.save();
  }

  String getJson() {
    return todo.getJson();
  }

  void fromJson(String? json) {
    if (json == null) {
      return;
    }
    try {
      TodoData newTodo = TodoData.fromJson(jsonDecode(json));
      todo = newTodo;
      update();
      todo.save();
    } catch (e) {
      return;
    }
  }

  void reorder(List<int> arr, int oldid, int newid) {
    todo.reorder(arr, oldid, newid);
    update();
    todo.save();
  }

  int getCnt() {
    return settings.cnt;
  }

  void incCnt() {
    settings.cnt++;
    settings.save();
  }

  List<MaterialColor> getColors(){
    return Settings.colors;
  }
  int getColor(){
    return settings.color;
  }

  void setColor(int c){
    settings.color = c;
    Get.changeTheme(
      ThemeData.dark().copyWith(
        // textTheme: Typography.whiteMountainView,
        colorScheme: ColorScheme.fromSwatch(
          brightness: Brightness.dark,
          primarySwatch: Settings.colors[c],
        ),
      )
    );
    update();
    settings.save();
  }
}
