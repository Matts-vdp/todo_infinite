import 'dart:convert';
import 'persistence/persistence.dart';
import 'package:flutter/material.dart';


class Settings {
  int cnt = 1;
  int color = 0;
  
  Settings(int i, int c){
    cnt = i;
    color = c;
  }

  // used to convert the object to json
  Map toJson() {
    return {
      'cnt': this.cnt,
      'color': this.color
    };
  }

  String getJson() {
    return jsonEncode(this);
  }

  // used to create a object from a json string
  factory Settings.fromJson(Map<String, dynamic> parsedJson) {
    return Settings(
        parsedJson["cnt"] ?? 1,
        parsedJson["color"] ?? 0,
    );
  }

  void save() {
    writeToPersistence(this.getJson(), "settings.json");
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
}