import 'dart:convert';
import 'file.dart';
import 'package:flutter/material.dart';


class Settings {
  int cnt = 1;
  int color = 0;
  
  Settings(int i, int c){
    cnt = i;
    color = c;
  }

  static const List<MaterialColor> colors = [
    Colors.purple,
    Colors.pink,
    Colors.blue,
    Colors.cyan,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.orange,
    Colors.red,
  ];
  // used to convert the object to json
  Map toJson() {
    return {
      'cnt': this.cnt,
      'color': this.color,
    };
  }

  String getJson() {
    return jsonEncode(this);
  }

  // used to create a object from a json string
  factory Settings.fromJson(Map<String, dynamic> parsedJson) {
    return Settings(parsedJson["cnt"], parsedJson["color"]);
  }

  void save() {
    writeFile(this.getJson(), "settings.json");
  }
}