import 'dart:convert';
import 'package:uuid/uuid.dart';

class Tags {
  List<Tag> tags;

  Tags(this.tags);

  Map toJson() { return {'tags': this.tags}; }

  factory Tags.fromJson(Map<String, dynamic> parsedJson) {
    List<Tag>? tags = (parsedJson["tags"] as List?)?.map((item)=>Tag.fromJson(item)).toList();
    return Tags(tags ?? []);
  }

  Tag? getById(String? id) {
    for (var tag in tags){
      if (tag.id == id) return tag;
    }
    return null;
  }

  List<Tag> toList() {
    return tags;
  }

  void addTag(String text) {
    tags.add(Tag(text));
  }

  void setColor(String id, int value) {
    getById(id)?.color = value;
  }

  void remove(String id) {
    tags.removeWhere((element) => element.id == id);
  }
}



class Tag {
  String id = Uuid().v4();
  String label;
  int color = 0;

  Tag(this.label);
  Tag.withColor(this.label, this.color);
  Tag.fromData(this.label, this.color, this.id);

  Map toJson() {
    return {
      'id': this.id,
      'label': this.label,
      'color': this.color,
    };
  }

  String getJson() {
    return jsonEncode(this);
  }

  // used to create a object from a json string
  factory Tag.fromJson(Map<String, dynamic> parsedJson) {
    return Tag.fromData(
      parsedJson["label"] ?? "",
      parsedJson["color"] ?? 0,
      parsedJson["id"] ?? Uuid().v4(),
    );
  }
}