import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:todo_infinite/data/todoData.dart';
import '../controllers/TodoController.dart';

void toClip({List<int>? arr}) async {
  final c = Get.find<TodoController>();

  String text;
  if (arr != null){
    text = jsonEncode(c.getTodo(arr).toJson());
  } else {
    text = c.getJson();
  }

  ClipboardData data = ClipboardData(text: text);
  await Clipboard.setData(data);
}

void toClipAsString(List<int> arr) async {
  final c = Get.find<TodoController>();

  String text = c.getTodo(arr).asString();

  ClipboardData data = ClipboardData(text: text);
  await Clipboard.setData(data);
}

// copies the data from clipboard to the saved data
void fromClip({List<int>? arr}) async {
  Clipboard.getData("text/plain").then((value) => {
    pasteTodo(arr, value)
  });
}

void pasteTodo(List<int>? arr, ClipboardData? value) {
  if (value == null || value.text == null) return;
  final c = Get.find<TodoController>();

  if (arr == null)
    c.fromJson(value.text);
  else {
    var todo = TodoData.fromJson(jsonDecode(value.text!));
    c.addTodoData(arr, todo);
  }
}