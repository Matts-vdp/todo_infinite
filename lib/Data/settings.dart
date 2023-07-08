import 'dart:convert';
import 'file.dart';
import 'package:flutter/material.dart';


class Settings {
  int cnt = 1;
  int color = 0;
  String syncKey = "";
  
  Settings(int i, int c, String s){
    cnt = i;
    color = c;
    syncKey = s;
  }

  static const List<MaterialColor> colors = [
    Colors.blue,
    Colors.cyan,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.orange,
    Colors.red,
    Colors.pink,
    Colors.purple,
    MaterialColor( //white
      0xFFFFFFFF,
      const <int, Color>{
        50: const Color(0xFFFFFFFF),
        100: const Color(0xFFFFFFFF),
        200: const Color(0xFFFFFFFF),
        300: const Color(0xFFFFFFFF),
        400: const Color(0xFFFFFFFF),
        500: const Color(0xFFFFFFFF),
        600: const Color(0xFFFFFFFF),
        700: const Color(0xFFFFFFFF),
        800: const Color(0xFFFFFFFF),
        900: const Color(0xFFFFFFFF),
      },
    ),
  ];
  // used to convert the object to json
  Map toJson() {
    return {
      'cnt': this.cnt,
      'color': this.color,
      'syncKey': this.syncKey
    };
  }

  String getJson() {
    return jsonEncode(this);
  }

  // used to create a object from a json string
  factory Settings.fromJson(Map<String, dynamic> parsedJson) {
    return Settings(parsedJson["cnt"], parsedJson["color"], parsedJson["syncKey"]);
  }

  void save() {
    writeFile(this.getJson(), "settings.json");
  }
}