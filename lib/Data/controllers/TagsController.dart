import 'package:get/get.dart';
import '../Tags.dart';


class TagsController extends GetxController {
  Tags tags = Tags([
    Tag.fromData("bug", 6, "a"),
    Tag.fromData("minor", 0, "b"),
    Tag.fromData("major", 2, "c"),
    Tag.fromData("extra", 5, "d")
  ]);

  TagsController();

  Tag? getTag(String? id) {
    return tags.getById(id);
  }

  List<Tag> list() {
    return tags.toList();
  }

  void addTag(String text) {
    tags.addTag(text);
    update();
  }

  void setColor(String id, int value) {
    tags.setColor(id, value);
    update();
  }

  void remove(String id) {
    tags.remove(id);
    update();
  }
}