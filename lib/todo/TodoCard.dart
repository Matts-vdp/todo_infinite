import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_infinite/data/todoData.dart';
import 'package:todo_infinite/utils/timeUtils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/controllers/TodoController.dart';
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
    return Card(
      child: Container(
        padding: EdgeInsets.all(10.0),
        width: double.infinity,
        child: Row(
          children: [
            IsDoneIcon(arr: arr),
            Info(arr: arr),
            OpenButton(arr: arr),
            SizedBox(width: 5),
            EnterButton(arr: arr)
          ],
        ),
      ),
    );
  }
}

class Info extends StatelessWidget {
  const Info({
    Key? key,
    required this.arr,
  }) : super(key: key);

  final List<int> arr;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GetBuilder<TodoController>(
        builder: (todo) {
          var todoData = todo.getTodo(arr);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Name(todo: todoData),
              Padding(
                padding: const EdgeInsets.only(top:5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (todoData.favorite)
                      Favorite(),
                    if (todoData.until != null)
                      Until(time: todoData.until!),
                    if (todoData.repeat != null)
                      Repeat(repeat: todoData.repeat!),
                  ],
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}

class Favorite extends StatelessWidget {
  const Favorite({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right:5),
      child: Icon(
          Icons.favorite,
          size: 12,
          color: Colors.yellow,
      ),
    );
  }
}

class Until extends StatelessWidget {
  const Until({
    Key? key,
    required this.time,
  }) : super(key: key);

  final DateTime time;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      padding: EdgeInsets.only(right: 5),
      child: Text(formatDate(time),
        style: TextStyle(
          fontSize: 10,
          color: isBeforeToday(time) ? Colors.red : Colors.white38
        ),),
    );
  }
}

class Repeat extends StatelessWidget {
  const Repeat({
    Key? key,
    required this.repeat,
  }) : super(key: key);

  final int repeat;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      child: Row(
        children: [
          Icon(Icons.repeat, size: 10,),
          Text(repeat.toString(),
            style: TextStyle(
                fontSize: 10,
                color: Colors.white38
            ),),
        ],
      ),
    );
  }
}

class EnterButton extends StatelessWidget {
  const EnterButton({
    Key? key,
    required this.arr,
  }) : super(key: key);

  final List<int> arr;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}

class OpenButton extends StatelessWidget {
  const OpenButton({
    Key? key,
    required this.arr,
  }) : super(key: key);

  final List<int> arr;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 40,
        child: GetBuilder<TodoController>(
          builder: (todo) => todo.getTodo(arr).sub.isNotEmpty
              ? SizedBox(
                  width: 30,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(padding: EdgeInsets.all(2)),
                    onPressed: () => todo.toggleOpen(arr),
                    child: Icon(todo.getOpen(arr)
                        ? Icons.expand_less_rounded
                        : Icons.notes),
                  ),
                )
              : Container(),
        ));
  }
}

class Name extends StatelessWidget {
  const Name({
    Key? key,
    required this.todo,
  }) : super(key: key);

  final TodoData todo;

  List<String> processText(String text) {
    var re = RegExp("\\s+");
    var urls = text.split(re).where((word) => word.isURL).toList();
    List<String> result = [];
    var endIndex = 0;
    for (var url in urls) {
      var index = text.indexOf(url, endIndex);
      result.add(text.substring(endIndex, index));
      result.add(url);
      endIndex = index + url.length;
    }
    result.add(text.substring(endIndex));
    return result;
  }

  @override
  Widget build(BuildContext context) {
    var words = processText(todo.text);
      return RichText(
        text: TextSpan(children: [
          for (var word in words)
            TextSpan(
              text: "$word",
              recognizer: new TapGestureRecognizer() ..onTap = word.isURL ?
                  (){openUrl(word);} :
                  (){},
              style: TextStyle(
                fontSize: 18,
                color: word.isURL ? Colors.blue : todo.done ? Colors.grey : Colors.white,
                decoration: todo.done
                    ? TextDecoration.lineThrough
                    : word.isURL ? TextDecoration.underline : TextDecoration.none,
              ),
            )
        ])
      );
  }

  Future<bool> openUrl(String word) {
    if (!word.startsWith("http"))
      word = "http://$word";
    var url = Uri.parse(word);
    return launchUrl(url, mode: LaunchMode.externalApplication);
  }
}

class IsDoneIcon extends StatelessWidget {
  const IsDoneIcon({
    Key? key,
    required this.arr,
  }) : super(key: key);

  final List<int> arr;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 40,
        child: GetBuilder<TodoController>(
            builder: (todo) => IconButton(
                  onPressed: () => todo.toggleDone(arr),
                  icon: Icon(todo.getDone(arr)
                      ? Icons.check_circle_outline
                      : Icons.radio_button_unchecked),
                )));
  }
}
