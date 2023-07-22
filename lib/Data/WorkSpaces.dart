import 'dart:convert';
import 'persistence/persistence.dart';


class WorkSpaces {
  String syncKey = "";
  List<String> workspaces = [];

  WorkSpaces(String key, List<String> w){
    syncKey = key;
    workspaces = w;
  }

  // used to convert the object to json
  Map toJson() {
    return {
      'syncKey': this.syncKey,
      'workspaces': this.workspaces
    };
  }

  String getJson() {
    return jsonEncode(this);
  }

  // used to create a object from a json string
  factory WorkSpaces.fromJson(Map<String, dynamic> parsedJson) {
    List<String>? w = (parsedJson["workspaces"] as List?)?.map((item)=>item as String).toList();
    return WorkSpaces(
        parsedJson["syncKey"] ?? "",
        w ?? []
    );
  }

  void save() {
    writeToPersistence(this.getJson(), "workspaces.json");
  }
}