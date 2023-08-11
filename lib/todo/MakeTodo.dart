import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../data/controllers/TodoController.dart';


// displays the button and textfield for adding new todos
class MakeTodo extends StatelessWidget {
  final fieldText = TextEditingController();
  final List<int> arr;
  MakeTodo({Key? key, required this.arr}) : super(key: key);

  // used when the add button is pressed
  void submitText(String str, TodoController c) {
    c.addTodo(arr, str.trim());
    fieldText.clear();
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<TodoController>();
    return Container(
        padding: EdgeInsets.all(5.0),
        child: Card(
            child: Container(
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  Expanded(
                    child: RawKeyboardListener(
                      focusNode: FocusNode(),
                      onKey: (value) {
                       if (value.isShiftPressed && value.isKeyPressed(LogicalKeyboardKey.enter))
                          submitText(fieldText.text, c);
                      },
                      child: TextField(
                        maxLines: 3,
                        minLines: 1,
                        controller: fieldText,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(),
                          labelText: 'New Todo',
                        ),
                        onChanged: (value) {
                          if (fieldText.text[0] == '\n') {
                            fieldText.text = fieldText.text.trimLeft();
                          }
                        },
                        onSubmitted: (String val) {
                          FocusScope.of(context).unfocus();
                          submitText(val, c);
                        },
                      ),
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