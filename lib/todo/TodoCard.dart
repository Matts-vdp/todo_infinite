import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
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
    return Card(
      child: Container(
        padding: EdgeInsets.all(10.0),
        width: double.infinity,
        //height: 60,
        child: Row(
          children: [
            IsDoneIcon(arr: arr),
            Name(arr: arr),
            OpenButton(arr: arr),
            SizedBox(width: 5),
            EnterButton(arr: arr)
          ],
        ),
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
    final Controller c = Get.find();
    return SizedBox(
        height: 40,
        child: GetBuilder<Controller>(
          builder: (todo) => todo.getTodo(arr).sub.isNotEmpty
              ? SizedBox(
                  width: 30,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(padding: EdgeInsets.all(2)),
                    onPressed: () => c.toggleOpen(arr),
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
    required this.arr,
  }) : super(key: key);

  final List<int> arr;

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
    return Expanded(
      child: GetBuilder<Controller>(builder: (todo) {
        var words = processText(todo.getText(arr));
        return RichText(
          text: TextSpan(children: [
            for (var word in words)
              TextSpan(
                text: "$word",
                recognizer: new TapGestureRecognizer() ..onTap = word.isURL ? 
                    (){launchUrl(Uri.parse(word));} :
                    (){},
                style: TextStyle(
                  fontSize: 18,
                  color: word.isURL ? Colors.blue : todo.getDone(arr) ? Colors.grey : Colors.white,
                  decoration: todo.getDone(arr)
                      ? TextDecoration.lineThrough
                      : word.isURL ? TextDecoration.underline : TextDecoration.none,
                ),
              )
          ])
        );
      }),
    );
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
    final Controller c = Get.find();
    return SizedBox(
        height: 40,
        child: GetBuilder<Controller>(
            builder: (todo) => IconButton(
                  onPressed: () => c.toggleDone(arr),
                  icon: Icon(todo.getDone(arr)
                      ? Icons.check_circle_outline
                      : Icons.radio_button_unchecked),
                )));
  }
}
