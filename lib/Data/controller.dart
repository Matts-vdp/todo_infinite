import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'TodoData.dart';
import 'settings.dart';

// is used to control the state management of the App
class Controller extends GetxController {
  TodoData todo = TodoData("To Do");
  Settings settings = Settings(1, 2);
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