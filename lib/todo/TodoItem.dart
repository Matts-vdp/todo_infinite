import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/controller.dart';
import '../dialogs/MoveDialog.dart';
import 'TodoCard.dart';

// Displays a todo item and its children when open
class Todo extends StatelessWidget {
  final List<int> arr;
  const Todo({Key? key, required this.arr}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.find();

    return Dismissible(
      key: UniqueKey(),
      confirmDismiss: (direction) {
        if (direction == DismissDirection.startToEnd) {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
          return showMoveDialog(context, arr);
        }
        return Future<bool>.value(true);
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          c.delTodo(arr);
        }
      },
      background: MoveBox(),
      secondaryBackground: RedBox(),
      direction: DismissDirection.horizontal,
      child: Column(
        children: [
          Center(
            child: TodoCard(arr: arr),
          ),
          GetBuilder<Controller>(
            //display the sub todo's when the todo is open and there are sub todo's
            builder: (todo) =>
            todo.getOpen(arr) && todo.getTodo(arr).sub.isNotEmpty
                ? ListTodo(arr: arr)
                : SizedBox(),
          ),
        ],
      ),
    );
  }
}

// used by Todo to display its sub elements
class ListTodo extends StatelessWidget {
  final List<int> arr;
  const ListTodo({Key? key, required this.arr}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 25),
        child: GetBuilder<Controller>(
          builder: (todo) => Column(
            children: [
              for (int i = 0; i < todo.getTodo(arr).sub.length; i++)
                Todo(arr: arr + [i],),
            ],
          ),
        ));
  }
}

// used by Todo to display a red box when being dismissed
class RedBox extends StatelessWidget {
  const RedBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red,
      child: Container(
          padding: EdgeInsets.all(10.0),
          width: double.infinity,
          height: 60,
          child: Row(
            children: [
              Expanded(
                child: Container(),
              ),
              Icon(Icons.delete)
            ],
          )),
    );
  }
}

// used by Todo to display a box when being dismissed to the right
class MoveBox extends StatelessWidget {
  const MoveBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Controller>(
      //display the sub todo's when the todo is open and there are sub todo's
      builder: (todo) => Card(
        color: todo.getColors()[todo.getColor()],
        child: Container(
            padding: EdgeInsets.all(10.0),
            width: double.infinity,
            height: 60,
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                Expanded(
                  child: Container(),
                ),
              ],
            )),
      ),
    );
  }
}

