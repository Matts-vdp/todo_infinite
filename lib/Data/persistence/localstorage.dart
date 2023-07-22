import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

// write a string to a local file
Future<void> writeToLocalStorage(String s, String file) async {
  var storage = LocalStorage(file);
  await storage.ready;
  await storage.setItem("data", s);
  storage.dispose();
}

//read a string from the local file
Future<String> readFromLocalStorage(String file) async {
  try {
    var storage = LocalStorage(file);
    await storage.ready;
    String content = await storage.getItem("data") ?? "";
    storage.dispose();
    debugPrint(content);
    return content;
  } catch (e) {
    return "";
  }
}