import 'package:get/get.dart';
import '../Tags.dart';


class TagsController extends GetxController {
  Tags tags = Tags([
    Tag.withColor("bug", 6),
    Tag.withColor("minor", 0),
    Tag.withColor("major", 2),
    Tag.withColor("extra", 4)
  ]);

  TagsController();

  Tag getTag(String id) {
    return tags.getById(id);
  }
}