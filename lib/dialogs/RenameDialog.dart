import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/controllers/TodoController.dart';


Future<void> showRenameDialog(BuildContext context, List<int> arr) async {
  final todos = Get.find<TodoController>();
  TextEditingController _textFieldController = TextEditingController(text: todos.getText(arr));

  void submit(String text) {
    todos.changeName(arr, text);
    Navigator.pop(context);
  }
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text("Change name"),
          children: <Widget>[
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextField(
                    maxLines: 4,
                    minLines: 1,
                    controller: _textFieldController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                    ),
                    onSubmitted: (String val) => submit(val),
                  ),
                ),
                Row(
                  children: [
                    IconButton(onPressed: () => submit(_textFieldController.text), icon: Icon(Icons.done)),
                    IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.cancel))
                  ],
                ),
              ],
            )
          ],
        );
      });
}