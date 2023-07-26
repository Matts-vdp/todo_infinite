import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../PersistedTodos.dart';
import '../Tags.dart';
import '../todoData.dart';
import 'TrashController.dart';
import 'WorkSpaceController.dart';

class TodoController extends GetxController {
  PersistedTodos todo;

  TodoController(this.todo);

  List<TodoReference> listFavorites() {
    var todos = todo.flatten();
    return todos.where((e) => e.data.favorite).toList();
  }

  List<PlannedTodoGroup> listPlanned() {
    var todos = todo.flatten().where((e) => e.data.until != null);

    var groups = Map<DateTime, List<TodoReference>>();
    for (var item in todos) {
      if (!groups.containsKey(item.data.until))
        groups[item.data.until!] = [item];
      else
        groups[item.data.until!]!.add(item);
    }

    var sortedTimes = groups.keys.toList();
    sortedTimes.sort((e, o) => e.compareTo(o));

    return sortedTimes
        .map((t) => PlannedTodoGroup(t, groups[t]!))
        .toList();
  }

  void toggleFavorite(List<int> arr) {
    todo.toggleFavorite(arr);
    updateSyncState();
    update();
  }

  void setUntil(List<int> arr, DateTime? time){
    todo.setUntil(arr, time);
    updateSyncState();
    update();
  }

  void setRepeat(List<int> arr, int? repeat){
    todo.setRepeat(arr, repeat);
    updateSyncState();
    update();
  }

  void setTag(List<int> arr, String? tag){
    todo.setTag(arr, tag);
    updateSyncState();
    update();
  }

  void setTodo(PersistedTodos todos) {
    todo = todos;
    update();
  }

  Future<void> loadTodos(String key) async {
    todo = await readTodosFromFile(key);
    update();
  }

  void changeName(List<int> arr, String name) {
    todo.changeName(arr, name);
    updateSyncState();
    update();
  }

  void toggleDone(List<int> arr) {
    todo.toggleDone(arr);
    updateSyncState();
    update();
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
    updateSyncState();
    update();
  }

  void delTodo(List<int> arr) {
    final TrashController c = Get.find<TrashController>();

    List<int> a = List<int>.from(arr);
    a.removeLast();
    String parentText = getText(a);
    c.toTrash(arr, parentText, getTodo(arr));

    todo.delTodo(arr);
    update();
    updateSyncState();
  }

  void addToParent(List<int> arr, String parent, TodoData todoData){
    debugPrint("a");
    List<int> parentArr = List<int>.from(arr);
    parentArr.removeLast();
    if (parent != getText(parentArr)) {
      arr = <int>[];
    }
    debugPrint("a");
    todo.addTodoData(parentArr, todoData);
    update();
    updateSyncState();
  }

  void moveTodo(List<int> from, List<int> to){
    todo.moveTo(from, to);
    updateSyncState();
    update();
  }

  void reorder(List<int> arr, int oldid, int newid) {
    todo.reorder(arr, oldid, newid);
    updateSyncState();
    update();
  }

  String getJson() {
    return todo.getJson();
  }

  void fromJson(String? json) {
    if (json == null) {
      return;
    }
    try {
      PersistedTodos newTodo = PersistedTodos.fromJson(jsonDecode(json), getSyncKey());
      todo = newTodo;
      updateSyncState();
      update();
      todo.save();
    } catch (e) {
      return;
    }
  }

  void updateSyncState() {
    final WorkSpaceController c = Get.find<WorkSpaceController>();
    c.updateSyncState(doUpdate: true);
  }

  void toTrash(List<int> arr) {}

  String getSyncKey() {
    final WorkSpaceController c = Get.find<WorkSpaceController>();
    return c.getSyncKey();
  }

  Tag? getTag(String? id) {
    return todo.getTag(id);
  }

  List<Tag> list() {
    return todo.tagList();
  }

  void addTag(String text) {
    todo.addTag(text);
    updateSyncState();
    update();
  }

  void setColor(String id, int value) {
    todo.setColor(id, value);
    updateSyncState();
    update();
  }

  void remove(String id) {
    todo.removeTag(id);
    updateSyncState();
    update();
  }
}

class PlannedTodoGroup {
  DateTime until;
  List<TodoReference> todos;

  PlannedTodoGroup(this.until, this.todos);
}