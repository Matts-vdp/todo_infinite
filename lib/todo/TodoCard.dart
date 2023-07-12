import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/controller.dart';
import 'TodoPage.dart';

// used by Todo to display a card with the text and needed buttons of the todo
class TodoCard extends StatelessWidget {
  const TodoCard({
    Key? key,
    required this.arr,
  }) : super(key: key);
  final List<int> arr;

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.find();
    return Card(
      child: Container(
        padding: EdgeInsets.all(10.0),
        width: double.infinity,
        //height: 60,
        child: Row(
          children: [
            SizedBox(
                height: 40,
                child: GetBuilder<Controller>(
                    builder: (todo) => IconButton(
                      onPressed: () => c.toggleDone(arr),
                      icon: Icon(todo.getDone(arr)
                          ? Icons.check_circle_outline
                          : Icons.radio_button_unchecked),
                    ))),
            Expanded(
              child: GetBuilder<Controller>(builder: (todo) {
                return Text(
                  "${todo.getText(arr)}",
                  style: TextStyle(
                    fontSize: 18,
                    color: todo.getDone(arr) ? Colors.grey : Colors.white,
                    decoration: todo.getDone(arr)
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                );
              }),
            ),
            SizedBox(
                height: 40,
                child: GetBuilder<Controller>(
                  builder: (todo) => todo.getTodo(arr).sub.isNotEmpty
                      ? SizedBox(
                    width: 30,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.all(2)),
                      onPressed: () => c.toggleOpen(arr),
                      child: Icon(todo.getOpen(arr)
                          ? Icons.expand_less_rounded
                          : Icons.notes),
                    ),
                  )
                      : Container(),
                )),
            SizedBox(width: 5),
            SizedBox(
              height: 40,
              child: SizedBox(
                width: 30,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.all(2)),
                  onPressed: () {
                    Get.offAll(() => TodoPage(arr: arr));
                  },
                  child: Icon(Icons.navigate_next_rounded),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}