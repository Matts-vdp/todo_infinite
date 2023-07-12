import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/controller.dart';
import 'package:flutter/services.dart';
import '../components/SyncIcon.dart';
import '../dialogs/RenameDialog.dart';
import '../notifications/Notifications.dart';
import '../settings/Settings.dart';
import '../trash/trash.dart';
import 'MakeTodo.dart';
import 'TodoItem.dart';

// Displays a todo chosen by the arr variable
class TodoPage extends StatelessWidget {
  final List<int> arr;
  const TodoPage({Key? key, required this.arr}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.find();
    return WillPopScope(
      onWillPop: () async {
        if (arr.isEmpty) {
          return true;
        }
        goToParent();
        return false;
      },
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              Text("Test")
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(33, 33, 33, 1),
          systemOverlayStyle: SystemUiOverlayStyle.light,
          title: GestureDetector(
            onDoubleTap: () => {showRenameDialog(context, arr)},
            child: GetBuilder<Controller>(
              builder: (todo) => Text('${todo.getText(arr)}'),
            ),
          ),
          leading: arr.isEmpty ? null :
          IconButton(
            onPressed: () {
              goToParent();
            },
            icon: Icon(
              Icons.keyboard_arrow_left_rounded,
            ),
          ),
          actions: [
            SyncIcon(),
            IconButton(
              onPressed: () {
                Get.to(() => Notifications());
              },
              icon: Icon(
                Icons.notifications_none_rounded,
              ),
            ),
            IconButton(
              onPressed: () {
                Get.to(() => Trash());
              },
              icon: Icon(
                Icons.delete_outline,
              ),
            ),
            IconButton(
              onPressed: () {
                Get.to(() => Settings());
              },
              icon: Icon(
                Icons.settings,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: GetBuilder<Controller>(
                builder: (todo) => ReorderableListView(
                  buildDefaultDragHandles: false,
                  keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.all(10),
                  children: [
                    //display a todo element for every item in the sub array
                    for (int i = 0; i < todo.getTodo(arr).sub.length; i++)
                      ReorderableDelayedDragStartListener(
                        index: i,
                        key: Key('$i'),
                        child: Todo(arr: arr + [i]),
                      )
                  ],
                  onReorder: (oldIndex, newIndex) {
                    c.reorder(arr, oldIndex, newIndex);
                  },
                ),
              ),
            ),
            MakeTodo(arr: arr),
          ],
        ),
      ),
    );
  }

  void goToParent() {
    List<int> a = List<int>.from(arr);
    a.removeLast();
    Get.offAll(() => TodoPage(arr: a));
  }
}