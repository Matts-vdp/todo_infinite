import 'dart:convert';
import '../data/todoData.dart';
import 'persistence/persistence.dart';

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
    //handle legacy save structure
    if (!parsedJson.containsKey("data")) {
      return PersistedTodos(DateTime.now(), TodoData.fromJson(parsedJson), key);
    }

    return PersistedTodos(
        DateTime.parse(parsedJson["lastMod"]),
        TodoData.fromJson(parsedJson["data"]),
        key
    );
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

  void save() {
    lastMod = DateTime.now();
    var path = dataPath(key);
    writeToPersistence(this.getJson(), path);
  }

  void addTodoData(List<int> parentArr, TodoData todoData) {
    data.addTodoData(parentArr, todoData);
    save();
  }

  List<TodoReference> flatten() {
    List<TodoReference> todos = [];
    data.listTodos(todos, []);
    return todos;
  }

  void toggleFavorite(List<int> arr) {
    data.toggleFavorite(arr);
    save();
  }

  void setUntil(List<int> arr, DateTime? time) {
    data.setUntil(arr, time);
    save();
  }
}

Future<PersistedTodos> readTodosFromFile(String key) async {
  var path = dataPath(key);
  var str = await readFromPersistence(path);
  if (str.isEmpty) return PersistedTodos(DateTime(0), TodoData("To Do"), key);
  return PersistedTodos.fromJson(jsonDecode(str), key);
}

String dataPath(String key) {
  var separator = key.isEmpty ? "" : "-";
  return key + separator + "data.json";
}