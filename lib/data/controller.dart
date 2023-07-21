import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../data/PersistedTodos.dart';
import 'httpsync.dart';
import 'settings.dart';
import 'trashData.dart';


// is used to control the state management of the App
class Controller extends GetxController {
  SyncState isSynced = SyncState.Unknown;
  PersistedTodos todo;
  Settings settings;
  TrashDataList trash;

  Controller(this.todo, this.settings, this.trash);

  Future<void> post() async {
    var success = await Sync.post(settings.syncKey, todo);
    if (!success) return;

    isSynced = SyncState.Synced;
    update();
  }

  Future<SyncState> fetch({bool overwrite = false}) async {
    var result = await Sync.fetch(settings.syncKey);
    if (result == null) {
      isSynced = SyncState.Unknown;
      update();
      return isSynced;
    }
    debugPrint(result.getJson());

    var oldStatus = isSynced;
    var status = todo.compareLastMod(result);
    if (status < 0) isSynced = SyncState.Outdated;
    if (status > 0) isSynced = SyncState.MoreRecent;
    if (status == 0) isSynced = SyncState.Synced;

    if (overwrite || isSynced == oldStatus) {
      await synchronize(result, isSynced);
      isSynced = SyncState.Synced;
    }

    update();
    return isSynced;
  }

  Future<void> synchronize(PersistedTodos result, SyncState status) async {
    if (status == SyncState.Synced) return;
    if (status == SyncState.Outdated) todo = result;
    if (status == SyncState.MoreRecent) await post();
  }

  Future<void> switchToWorkSpace(String key) async {
    setSyncKey(key);
    isSynced = SyncState.Unknown;
    todo = await readTodosFromFile(key);
    fetch();
    update();
  }



  void changeName(List<int> arr, String name) {
    todo.changeName(arr, name);
    update();
    isSynced = SyncState.Unknown;
  }

  void toggleDone(List<int> arr) {
    todo.toggleDone(arr);
    update();
    isSynced = SyncState.Unknown;
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
    isSynced = SyncState.Unknown;
  }

  void delTodo(List<int> arr) {
    toTrash(arr);
    todo.delTodo(arr);
    update();
    isSynced = SyncState.Unknown;
  }

  void moveTodo(List<int> from, List<int> to){
    todo.moveTo(from, to);
    update();
    isSynced = SyncState.Unknown;
  }

  String getJson() {
    return todo.getJson();
  }

  void fromJson(String? json) {
    if (json == null) {
      return;
    }
    try {
      PersistedTodos newTodo = PersistedTodos.fromJson(jsonDecode(json), settings.syncKey);
      todo = newTodo;
      update();
      isSynced = SyncState.Unknown;
      todo.save();
    } catch (e) {
      return;
    }
  }

  void reorder(List<int> arr, int oldid, int newid) {
    todo.reorder(arr, oldid, newid);
    update();
    isSynced = SyncState.Unknown;
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
    isSynced = SyncState.Unknown;
    todo.save();
  }

  void setSyncKey(String key){
    settings.syncKey = key;
    settings.save();
  }

  String getSyncKey(){
    return settings.syncKey;
  }

  SyncState synced(){
    return isSynced;
  }

  List<String> getWorkSpaces(){
    return settings.workspaces;
  }

  void addWorkSpace(String workspace){
    if (settings.workspaces.contains(workspace)) return;

    settings.workspaces.add(workspace);
    settings.save();
    update();
  }

  void deleteWorkSpace(String workspace){
    if (!settings.workspaces.contains(workspace)) return;

    settings.workspaces.remove(workspace);
    settings.save();
    update();
  }
}

enum SyncState {
  Unknown,
  Outdated,
  Synced,
  MoreRecent
}