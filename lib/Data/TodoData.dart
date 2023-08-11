import 'package:flutter/material.dart';

class TodoData {
  String text;
  bool done = false;
  bool open = false;
  bool favorite = false;
  int? repeat;
  DateTime? until;
  String? tag;
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
    if (!t.done && t.repeat != null && t.until != null) {
      debugPrint(t.repeat.toString());
      debugPrint(t.until.toString());
      t.until = t.until!.add(Duration(days: t.repeat!));
    }
    else
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
  TodoData newData(bool done, bool favorite, List<TodoData> sub, DateTime? until, int? repeat, String? tag) {
    this.done = done;
    this.favorite = favorite;
    this.sub = sub;
    this.until = until;
    this.repeat = repeat;
    this.tag = tag;
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

  void toggleFavorite(List<int> arr){
    var todo = getTodo(arr);
    todo.favorite = !todo.favorite;
  }

  void setUntil(List<int> arr, DateTime? time) {
    getTodo(arr).until = time;
  }

  void setRepeat(List<int> arr, int? repeat) {
    getTodo(arr).repeat = repeat;
  }

  void setTag(List<int> arr, String? tag) {
    getTodo(arr).tag = tag;
  }

  // used to convert the object to json
  Map toJson() {
    List<Map>? subs = this.sub.map((i) => i.toJson()).toList();

    return {
      'text': this.text,
      'done': this.done,
      'until': this.until?.toIso8601String(),
      'favorite' : this.favorite,
      'repeat' : this.repeat,
      'tag' : this.tag,
      'sub': subs,
    };
  }

  // used to create a TodoData object from a json string
  factory TodoData.fromJson(Map<String, dynamic> parsedJson) {
    List<dynamic> l = parsedJson['sub'];
    List<TodoData> s = <TodoData>[];
    for (int i = 0; i < l.length; i++) {
      s.add(TodoData.fromJson(l[i]));
    }

    var time = parsedJson['until'];

    return TodoData(parsedJson['text']).newData(
      parsedJson['done'] ?? false,
      parsedJson['favorite'] ?? false,
      s,
      time == null ? null : DateTime.parse(time),
      parsedJson['repeat'],
      parsedJson['tag'],
    );
  }

  void listTodos(List<TodoReference> todos, List<int> arr) {
    if (arr.isNotEmpty)
      todos.add(TodoReference(arr, this));
    for (var i=0; i<sub.length; i++){
      sub[i].listTodos(todos, [...arr, i]);
    }
  }

  String asString({int depth = 0, String separator = "    "}) {
    var str = "${separator * depth}- $text\n";
    for (var todo in sub) {
      str += todo.asString(depth: depth + 1);
    }
    return str;
  }
}

class TodoReference {
  TodoData data;
  List<int> arr;

  TodoReference(this.arr, this.data);
}



