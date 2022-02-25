import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Data/controller.dart';

class Trash extends StatelessWidget {
  const Trash({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(33, 33, 33, 1),
        title: Text('Trash'),
      ),
      body: GetBuilder<Controller>(
          builder: (todo) => ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.all(10),
            children: [ //display a todo element for every item in the array
              for (int i=0; i<todo.trash.items.length; i++) 
                TodoTrashCard(arr: i)
            ],
          ),
        ),
    );
  }
}


class TodoTrashCard extends StatelessWidget {
  const TodoTrashCard({ Key? key,required this.arr, }) : super(key: key);
  final int arr;

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
            Expanded(
              child:
              GetBuilder<Controller>(
                builder: (todo) {
                  return Text(todo.trash.items[arr].data.text,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  );
                }
              ),
            ),
            SizedBox(
              height: 40,
              child: SizedBox(
                width: 30,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.all(2)),
                  onPressed: () { 
                    c.fromTrash(arr);
                  }, 
                  child: Icon(Icons.restore_from_trash ),
                ), 
              ),
            )
          ],
        ),
      ),
    );
  }
}