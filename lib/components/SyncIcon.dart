import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_infinite/data/PersistedTodos.dart';
import 'package:todo_infinite/data/todoData.dart';
import '../data/controller.dart';

class SyncIcon extends StatelessWidget {
  const SyncIcon({Key? key}) : super(key: key);

  void test(){

  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Controller>(builder: (todo)=>
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: IconButton(
            icon: Icon(
              todo.isSynced ? Icons.cloud_sync : Icons.sync_disabled,
              color: todo.isSynced ? Colors.green : Colors.red,),
            onPressed: () => {
              test()
            },
          )
        )
    );
  }
}