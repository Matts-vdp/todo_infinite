import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:todo_infinite/data/PersistedTodos.dart';
import 'httpsync.dart';
import 'settings.dart';
import 'trashData.dart';

// is used to control the state management of the App
class Controller extends GetxController {
  bool isSynced = false;
  // TodoData todo;
  PersistedTodos todo;
  Settings settings;
  TrashDataList trash;

  Controller(this.todo, this.settings, this.trash);

  Future<void> post(String key) async {
    setSyncKey(key);
    var success = await Sync.post(key, todo);
    isSynced = success;
    update();
  }

  Future<void> fetch(String key) async {
    setSyncKey(key);
    var result = await Sync.fetch(key);
    if (result == null) return;
    todo = result;
    isSynced = true;
    update();
  }

  Future<void> switchToWorkSpace(String key) async {
    await fetch(key);
  }

  void changeName(List<int> arr, String name) {
    todo.changeName(arr, name);
    update();
    isSynced = false;
  }

  void toggleDone(List<int> arr) {
    todo.toggleDone(arr);
    update();
    isSynced = false;
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
    isSynced = false;
  }

  void delTodo(List<int> arr) {
    toTrash(arr);
    todo.delTodo(arr);
    update();
    isSynced = false;
  }

  void moveTodo(List<int> from, List<int> to){
    todo.moveTo(from, to);
    update();
    isSynced = false;
  }

  String getJson() {
    return todo.getJson();
  }

  void fromJson(String? json) {
    if (json == null) {
      return;
    }
    try {
      PersistedTodos newTodo = PersistedTodos.fromJson(jsonDecode(json));
      todo = newTodo;
      update();
      isSynced = false;
      todo.save();
    } catch (e) {
      return;
    }
  }

  void reorder(List<int> arr, int oldid, int newid) {
    todo.reorder(arr, oldid, newid);
    update();
    isSynced = false;
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

  void toTrash(List<int> arr) {
    List<int> a = List<int>.from(arr);
    a.removeLast();
    String parentText = getText(a);
    trash.add(arr, getTodo(arr), parentText);
    trash.save();
  }

  void fromTrash(int i) {
    List<int> arr = List<int>.from(trash.items[i].arr);
    arr.removeLast();
    if (trash.items[i].parent != getText(arr)) {
      arr = <int>[];
    }
    todo.data.addTodoData(arr, trash.items[i].data);
    trash.items.removeAt(i);
    update();
    trash.save();
    isSynced = false;
    todo.save();
  }

  String getSyncKey(){
    return settings.syncKey;
  }

  void setSyncKey(String key){
    settings.syncKey = key;
    settings.save();
  }

  bool synced(){
    return isSynced;
  }

  List<String> getWorkSpaces(){
    return settings.workspaces;
  }

  void addWorkSpace(String workspace){
    settings.workspaces.add(workspace);
    settings.save();
    update();
  }
}