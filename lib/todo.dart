import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Data/controller.dart';
import 'package:flutter/services.dart';
import 'extra.dart';
import 'trash.dart';

// Displays a todo chosen by the arr variable
class TodoHome extends StatelessWidget {
  final List<int> arr;
  const TodoHome({Key? key, required this.arr}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.find();
    return WillPopScope(
      onWillPop: () async {
        if (arr.isEmpty) {
          return true;
        }
        List<int> a = List<int>.from(arr);
        a.removeLast();
        Get.offAll(() => TodoHome(arr: a));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(33, 33, 33, 1),
          systemOverlayStyle: SystemUiOverlayStyle.light,
          title: GestureDetector(
            onDoubleTap: () => {showRenameDialog(context, arr)},
            child: GetBuilder<Controller>(
              builder: (todo) => Text('${c.getText(arr)}'),
            ),
          ),
          leading: GetBuilder<Controller>(
            //display a back button when the chosen todo is not the root
            builder: (todo) => arr.isEmpty
                ? Icon(Icons.home)
                : IconButton(
                    onPressed: () {
                      //display the todo above the current one
                      if (arr.isEmpty) {
                        return;
                      }
                      List<int> a = List<int>.from(arr);
                      a.removeLast();
                      Get.offAll(() => TodoHome(arr: a));
                    },
                    icon: Icon(
                      Icons.keyboard_arrow_left_rounded,
                    ),
                  ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Get.to(() => Notifications());
              },
              icon: Icon(
                Icons.notifications_none_rounded,
              ),
            ),
            IconButton(
              onPressed: () {
                Get.to(() => Trash());
              },
              icon: Icon(
                Icons.delete_outline,
              ),
            ),
            IconButton(
              onPressed: () {
                Get.to(() => Settings());
              },
              icon: Icon(
                Icons.settings,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: GetBuilder<Controller>(
                builder: (todo) => ReorderableListView(
                  buildDefaultDragHandles: false,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.all(10),
                  children: [
                    //display a todo element for every item in the sub array
                    for (int i = 0; i < todo.getTodo(arr).sub.length; i++)
                      ReorderableDelayedDragStartListener(
                        index: i,
                        key: Key('$i'),
                        child: Todo(arr: arr + [i]),
                      )
                  ],
                  onReorder: (oldIndex, newIndex) {
                    c.reorder(arr, oldIndex, newIndex);
                  },
                ),
              ),
            ),
            MakeTodo(arr: arr),
          ],
        ),
      ),
    );
  }
}

Future<void> showRenameDialog(BuildContext context, List<int> arr) async {
  final Controller c = Get.find();
  TextEditingController _textFieldController =
      TextEditingController(text: c.getText(arr));
  
  void submit(String text) {
    c.changeName(arr, text);
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

// displays the button and textfield for adding new todos
class MakeTodo extends StatelessWidget {
  final fieldText = TextEditingController();
  final List<int> arr;
  MakeTodo({Key? key, required this.arr}) : super(key: key);

  // used when the add button is pressed
  void submitText(String str, Controller c) {
    c.addTodo(arr, str);
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

// Used by TodoHome to display a todo element on screen
class Todo extends StatelessWidget {
  final List<int> arr;
  const Todo({Key? key, required this.arr}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.find();

    return Dismissible(
      key: UniqueKey(),
      confirmDismiss: (direction) {
        if (direction == DismissDirection.startToEnd) {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
          return showMoveDialog(context, arr);
        }
        return Future<bool>.value(true);
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          c.delTodo(arr);
        }
      },
      background: MoveBox(),
      secondaryBackground: RedBox(),
      direction: DismissDirection.horizontal,
      child: Column(
        children: [
          Center(
            child: TodoCard(arr: arr),
          ),
          GetBuilder<Controller>(
            //display the sub todo's when the todo is open and there are sub todo's
            builder: (todo) =>
                todo.getOpen(arr) && todo.getTodo(arr).sub.isNotEmpty
                    ? ListTodo(arr: arr)
                    : SizedBox(),
          ),
        ],
      ),
    );
  }
}

Future<bool> showMoveDialog(BuildContext context, List<int> arr) async {
  final Controller c = Get.find();
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
                      color: c.getColors()[c.getColor()],
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
            for (int i = 0; i < c.getTodo(parr).sub.length; i++)
              if (i != arr[arr.length - 1])
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, i);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.chevron_right_rounded,
                        color: c.getColors()[c.getColor()],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Text(
                          c.getText([...parr, i]),
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
      c.moveTodo(arr, parr);
      return Future<bool>.value(true);
    }
    return Future<bool>.value(false);
  } else {
    parr.add(res);
    c.moveTodo(arr, parr);
    return Future<bool>.value(true);
  }
}

// used by Todo to display a red box when being dismissed
class RedBox extends StatelessWidget {
  const RedBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red,
      child: Container(
          padding: EdgeInsets.all(10.0),
          width: double.infinity,
          height: 60,
          child: Row(
            children: [
              Expanded(
                child: Container(),
              ),
              Icon(Icons.delete)
            ],
          )),
    );
  }
}

// used by Todo to display a box when being dismissed to the right
class MoveBox extends StatelessWidget {
  const MoveBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Controller>(
      //display the sub todo's when the todo is open and there are sub todo's
      builder: (todo) => Card(
        color: todo.getColors()[todo.getColor()],
        child: Container(
            padding: EdgeInsets.all(10.0),
            width: double.infinity,
            height: 60,
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                Expanded(
                  child: Container(),
                ),
              ],
            )),
      ),
    );
  }
}

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
                    Get.offAll(() => TodoHome(arr: arr));
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

// used by Todo to display its sub elements
class ListTodo extends StatelessWidget {
  final List<int> arr;
  const ListTodo({Key? key, required this.arr}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 25),
        child: GetBuilder<Controller>(
          builder: (todo) => Column(
            children: [
              for (int i = 0; i < todo.getTodo(arr).sub.length; i++)
                Todo(
                  arr: arr + [i],
                ),
            ],
          ),
        ));
  }
}
