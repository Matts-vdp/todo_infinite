import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_infinite/todo/TodoItem.dart';
import 'package:todo_infinite/utils/timeUtils.dart';
import '../components/SyncIcon.dart';
import '../components/actions/actions.dart';
import '../data/controllers/TodoController.dart';

// Displays the settings tab
class PlanningPage extends StatelessWidget {
  const PlanningPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(33, 33, 33, 1),
        title: Text('Planning'),
        actions: [
          SyncIcon(),
          NotificationAction(),
          TrashAction(),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: GetBuilder<TodoController>(
          builder: (c) => ListView(
            children: [
              for (var group in c.listPlanned())
                PlannedGroup(group: group)
            ],
          ),
        ),
      ),
    );
  }
}

class PlannedGroup extends StatelessWidget {
  final PlannedTodoGroup group;

  const PlannedGroup({
    Key? key, required this.group,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isTooOld = group.until.compareTo(DateTime.now()) < 0;

    return Column(
      children: [
        Text(
            formatDate(group.until),
            style: TextStyle(
                fontSize: 18,
                color: isTooOld ? Colors.red : Colors.white,
                fontWeight: FontWeight.bold
            )),
        SizedBox.fromSize(size: Size.fromHeight(5)),
        for (var todo in group.todos)
          Todo(arr: todo.arr),
        SizedBox.fromSize(size: Size.fromHeight(20))
      ],
    );
  }
}
