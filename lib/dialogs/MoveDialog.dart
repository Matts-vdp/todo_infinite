import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/controllers/SettingsController.dart';
import '../data/controllers/TodoController.dart';


Future<bool> showMoveDialog(BuildContext context, List<int> arr) async {
  final todos = Get.find<TodoController>();
  final settings = Get.find<SettingsController>();

  List<int> parr = [...arr];
  int? res = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        parr.removeLast();
        return SimpleDialog(
          title: Column(
            children: [Text('Move item to:'), Divider()],
          ),
          children: <Widget>[
            if (parr.length > 0)
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, -1);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      color: settings.currentColor(),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "..",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            for (int i = 0; i < todos.getTodo(parr).sub.length; i++)
              if (i != arr[arr.length - 1])
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, i);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.chevron_right_rounded,
                        color: settings.currentColor(),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Text(
                          todos.getText([...parr, i]),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          ],
        );
      });
  if (res == null) {
    return Future<bool>.value(false);
  } else if (res == -1) {
    if (parr.length > 0) {
      parr.removeLast();
      todos.moveTodo(arr, parr);
      return Future<bool>.value(true);
    }
    return Future<bool>.value(false);
  } else {
    parr.add(res);
    todos.moveTodo(arr, parr);
    return Future<bool>.value(true);
  }
}