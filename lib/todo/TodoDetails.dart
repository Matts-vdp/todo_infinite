import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_infinite/data/todoData.dart';
import 'package:todo_infinite/utils/timeUtils.dart';
import '../data/controllers/TodoController.dart';

class TodoDetails extends StatelessWidget {
  const TodoDetails({
    Key? key,
    required this.arr,
  }) : super(key: key);

  final List<int> arr;

  @override
  Widget build(BuildContext context) {
    if (arr.isEmpty) return Container();
    return GetBuilder<TodoController>(
        builder: (todo) {
          var todoData = todo.getTodo(arr);
          return Column(
            children: [
              SizedBox.fromSize(size: Size.fromHeight(15)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FavoriteButton(arr: arr, todoData: todoData),
                  UntilPicker(arr: arr, todoData: todoData),
                ],
              ),

            ],
          );
        }
    );
  }
}

class UntilPicker extends StatelessWidget {
  const UntilPicker({
    Key? key,
    required this.arr,
    required this.todoData,
  }) : super(key: key);

  final List<int> arr;
  final TodoData todoData;

  @override
  Widget build(BuildContext context) {
    final todo = Get.find<TodoController>();
    return OutlinedButton(
        onPressed: () {
          showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now().add(Duration(days: -365)),
              lastDate: DateTime.now().add(Duration(days: 365*2))
          ).then((value) {
            var time = value == null ? null : DateTime(value.year, value.month, value.day);
            todo.setUntil(arr, time);
          });
        },
        child: todoData.until != null ?
          Text("Until: ${formatDate(todoData.until!)}") :
          Text("Until")
    );
  }
}

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    Key? key,
    required this.arr,
    required this.todoData,
  }) : super(key: key);

  final List<int> arr;
  final TodoData todoData;

  @override
  Widget build(BuildContext context) {
    final todo = Get.find<TodoController>();
    return IconButton(
        onPressed: (){todo.toggleFavorite(arr);},
        icon: Icon(todoData.favorite ? Icons.favorite : Icons.favorite_border, color: Colors.amber,)
    );
  }
}