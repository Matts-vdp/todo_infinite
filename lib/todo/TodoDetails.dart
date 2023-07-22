import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
              SizedBox.fromSize(size: Size.fromHeight(10)),
              Text("Details", style: TextStyle(color: Colors.white30)),
              IconButton(
                  onPressed: (){todo.toggleFavorite(arr);},
                  icon: Icon(todoData.favorite ? Icons.favorite : Icons.favorite_border, color: Colors.amber,)
              ),
            ],
          );
        }
    );
  }
}