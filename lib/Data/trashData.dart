import 'dart:convert';
import 'file.dart';
import 'todoData.dart';
export 'todoData.dart';

class TrashDataList {
  List<TrashData> items = <TrashData>[];
  int maxItems = 10;

  TrashDataList();
  TrashDataList.fromList(this.items);

  void add(List<int> arr, TodoData td, String parentText) {
    TrashData newItem = TrashData(arr, td, parentText);
    items.add(newItem);
    if (items.length > maxItems) {
      items.removeAt(0);
    }
  }

  // used to convert the object to json
  Map toJson() {
    List<Map>? itjs = this.items.map((i) => i.toJson()).toList();
    return {
      'items': itjs,
    };
  }

  String getJson() {
    return jsonEncode(this);
  }

  factory TrashDataList.fromJson(Map<String, dynamic> parsedJson) {
    List<dynamic> l = parsedJson['items'];
    List<TrashData> itms = <TrashData>[];
    for (int i = 0; i < l.length; i++) {
      itms.add(TrashData.fromJson(l[i]));
    }
    return TrashDataList.fromList(itms);
  }

  void save() {
    writeFile(this.getJson(), "trash.json");
  }
}

class TrashData {
  List<int> arr;
  String parent;
  TodoData data;
  TrashData(this.arr, this.data, this.parent);
  
  // used to convert the object to json
  Map toJson() {
    return {
      'arr': this.arr,
      'data': this.data,
      'parent': this.parent,
    };
  }

  String getJson() {
    return jsonEncode(this);
  }

  factory TrashData.fromJson(Map<String, dynamic> parsedJson) {
    TodoData d = TodoData.fromJson(parsedJson["data"]);
    return TrashData(parsedJson["arr"].cast<int>(), d, parsedJson['parent']);
  }
}