import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_infinite/components/HomeDrawer.dart';
import 'package:todo_infinite/todo/TodoItem.dart';
import '../components/SyncIcon.dart';
import '../components/actions/actions.dart';
import '../data/controllers/TodoController.dart';

// Displays the settings tab
class Favorites extends StatelessWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(33, 33, 33, 1),
        title: Text('Favorites'),
        actions: [
          SyncIcon(),
          NotificationAction(),
          HomeAction()
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: GetBuilder<TodoController>(
          builder: (c) => ListView(
            children: [
              for (var todo in c.listFavorites())
                Todo(arr: todo.arr)
            ],
          ),
        ),
      ),
    );
  }
}
