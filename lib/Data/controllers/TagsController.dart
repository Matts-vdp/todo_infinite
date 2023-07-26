import 'package:get/get.dart';
import '../Tags.dart';


class TagsController extends GetxController {
  Tags tags;

  TagsController(this.tags);

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