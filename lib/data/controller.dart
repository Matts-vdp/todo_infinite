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

  Controller(this.todo, this.settings, this.trash) {
    if (settings.syncKey.isNotEmpty)
      fetch();
  }

  Future<void> post() async {
    var status = await Sync.post(settings.syncKey, todo);
    isSynced = mapSyncStatus(status);
    update();
  }

  Future<SyncState> fetch({bool overwrite = false}) async {
    var result = await Sync.fetch(settings.syncKey);
    if (result.status == Status.Other)
      isSynced = SyncState.Unknown;
    else if (result.status == Status.Offline)
      isSynced = SyncState.Offline;
    else if (result.status == Status.Success) {
      var oldStatus = isSynced;
      var status = todo.compareLastMod(result.data!);
      if (status < 0) isSynced = SyncState.Outdated;
      if (status > 0) isSynced = SyncState.MoreRecent;
      if (status == 0) isSynced = SyncState.Synced;

      if (overwrite || isSynced == oldStatus) {
        await synchronize(result.data!, isSynced);
        isSynced = SyncState.Synced;
      }
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
    toTrash(arr);
    todo.delTodo(arr);
    updateSyncState();
    update();
  }

  void moveTodo(List<int> from, List<int> to){
    todo.moveTo(from, to);
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
      PersistedTodos newTodo = PersistedTodos.fromJson(jsonDecode(json), settings.syncKey);
      todo = newTodo;
      updateSyncState();
      update();
      todo.save();
    } catch (e) {
      return;
    }
  }

  void reorder(List<int> arr, int oldid, int newid) {
    todo.reorder(arr, oldid, newid);
    updateSyncState();
    update();
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
    updateSyncState();
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

  void updateSyncState(){
    if (isSynced == SyncState.Offline) return;
    if (isSynced == SyncState.Unknown) return;
    isSynced = SyncState.MoreRecent;
  }
}

enum SyncState {
  Unknown,
  Offline,
  Outdated,
  Synced,
  MoreRecent
}
SyncState mapSyncStatus(Status status) {
  switch (status) {
    case Status.Success: return SyncState.Synced;
    case Status.Offline: return SyncState.Offline;
  }
  return SyncState.Unknown;
}