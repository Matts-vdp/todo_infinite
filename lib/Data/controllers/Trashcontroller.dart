import 'package:get/get.dart';
import '../trashData.dart';
import 'TodoController.dart';

// is used to control the state management of the App
class TrashController extends GetxController {
  TrashDataList trash;

  TrashController(this.trash);

  void toTrash(List<int> arr, String parentText, TodoData todo) {
    trash.add(arr, todo, parentText);
    update();
    trash.save();
  }

  void fromTrash(int i) {
    final TodoController c = Get.find<TodoController>();

    c.addToParent(trash.items[i].arr, trash.items[i].parent, trash.items[i].data);

    trash.items.removeAt(i);
    update();
    trash.save();
  }
}

