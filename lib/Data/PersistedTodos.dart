import 'dart:convert';
import '../data/todoData.dart';
import 'Tags.dart';
import 'persistence/persistence.dart';

class PersistedTodos {
  DateTime lastMod;
  TodoData data;
  Tags tags;
  String key;

  PersistedTodos(this.lastMod, this.data, this.tags, this.key);

  // used to convert the object to json
  Map<String, dynamic> toJson() {
    Map? todo = data.toJson();

    return {
      'lastMod': lastMod.toIso8601String(),
      'data': todo,
      'tags': tags.toJson()
    };
  }

  String getJson() {
    return jsonEncode(this.toJson());
  }

  // used to create a TodoData object from a json string
  factory PersistedTodos.fromJson(Map<String, dynamic> parsedJson, String key) {
    //handle legacy save structure
    if (!parsedJson.containsKey("data")) {
      return PersistedTodos(DateTime.now(), TodoData.fromJson(parsedJson), Tags([]), key);
    }

    var tags = parsedJson['tags'];
    return PersistedTodos(
        DateTime.parse(parsedJson["lastMod"]),
        TodoData.fromJson(parsedJson["data"]),
        tags == null ? Tags([]) : Tags.fromJson(tags),
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

  void save({updateLastMod = true}) {
    if (updateLastMod)
      lastMod = DateTime.now();
    var path = dataPath(key);
    writeToPersistence(this.getJson(), path);
  }

  void backUp(){
    writeToPersistence(this.getJson(), "backup.json");
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

  void setRepeat(List<int> arr, int? repeat) {
    data.setRepeat(arr, repeat);
    save();
  }

  void setTag(List<int> arr, String? tag) {
    data.setTag(arr, tag);
    save();
  }

  Tag? getTag(String? id) {
    return tags.getById(id);
  }

  List<Tag> tagList() {
    return tags.toList();
  }

  void addTag(String text) {
    tags.addTag(text);
    save();
  }

  void setColor(String id, int value) {
    tags.setColor(id, value);
    save();
  }

  void removeTag(String id) {
    tags.remove(id);
    save();
  }
}

Future<PersistedTodos> readTodosFromFile(String key, {bool useBackup = false}) async {
  var path = useBackup ? "backup.json" : dataPath(key);
  var str = await readFromPersistence(path);
  if (str.isEmpty) return PersistedTodos(DateTime(0), TodoData("To Do"), Tags([]), key);
  return PersistedTodos.fromJson(jsonDecode(str), key);
}

String dataPath(String key) {
  var separator = key.isEmpty ? "" : "-";
  return key + separator + "data.json";
}