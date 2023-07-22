import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/HomeDrawer.dart';
import '../components/actions/actions.dart';
import '../data/controllers/TodoController.dart';
import 'package:flutter/services.dart';
import '../components/SyncIcon.dart';
import '../dialogs/RenameDialog.dart';
import 'MakeTodo.dart';
import 'TodoDetails.dart';
import 'TodoItem.dart';

// Displays a todo chosen by the arr variable
class TodoPage extends StatelessWidget {
  final List<int> arr;
  const TodoPage({Key? key, required this.arr}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (arr.isEmpty) {
          return true;
        }
        goToParent();
        return false;
      },
      child: Scaffold(
        drawer: HomeDrawer(),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(33, 33, 33, 1),
          systemOverlayStyle: SystemUiOverlayStyle.light,
          title: GestureDetector(
            onDoubleTap: () => {showRenameDialog(context, arr)},
            child: GetBuilder<TodoController>(
              builder: (todo) => Text('${todo.getText(arr)}'),
            ),
          ),
          leading: arr.isEmpty ? null : IconButton(
            onPressed: () {
              goToParent();
            },
            icon: Icon(
              Icons.keyboard_arrow_left_rounded,
            ),
          ),

          actions: [
            SyncIcon(),
            NotificationAction(),
            if (arr.isNotEmpty)
              HomeAction(),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: GetBuilder<TodoController>(
                builder: (todo) => ReorderableListView(
                  buildDefaultDragHandles: false,
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  footer: TodoDetails(arr: arr),
                  padding: EdgeInsets.all(10),
                  children: [
                    //display a todo element for every item in the sub array
                    for (int i = 0; i < todo.getTodo(arr).sub.length; i++)
                      ReorderableDelayedDragStartListener(
                        index: i,
                        key: Key('$i'),
                        child: Todo(arr: arr + [i]),
                      ),
                  ],
                  onReorder: (oldIndex, newIndex) {
                    todo.reorder(arr, oldIndex, newIndex);
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