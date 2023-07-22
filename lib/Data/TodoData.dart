import 'dart:convert';
import 'persistence/persistence.dart';

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

  void changeName(List<int> arr, String name) {
    TodoData t = getTodo(arr);
    t.text = name;
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
    writeToPersistence(this.getJson(), "data.json");
  }
}



