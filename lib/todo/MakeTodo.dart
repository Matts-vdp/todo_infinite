import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/controller.dart';


// displays the button and textfield for adding new todos
class MakeTodo extends StatelessWidget {
  final fieldText = TextEditingController();
  final List<int> arr;
  MakeTodo({Key? key, required this.arr}) : super(key: key);

  // used when the add button is pressed
  void submitText(String str, Controller c) {
    FocusManager.instance.primaryFocus?.unfocus();
    c.addTodo(arr, str.trim());
    fieldText.clear();
  }

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.find();
    return Container(
        padding: EdgeInsets.all(5.0),
        child: Card(
            child: Container(
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      maxLines: 3,
                      minLines: 1,
                      controller: fieldText,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        border: OutlineInputBorder(),
                        labelText: 'New Todo',
                      ),
                      onSubmitted: (String val) => submitText(val, c),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(padding: EdgeInsets.all(2)),
                        onPressed: () => submitText(fieldText.text, c),
                        child: Icon(Icons.add)),
                  ),
                ],
              ),
            )));
  }
}