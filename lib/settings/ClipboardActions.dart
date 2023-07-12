import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../data/controller.dart';


class ClipboardActions extends StatelessWidget {
  const ClipboardActions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Export to clipboard as json"),
                OutlinedButton(
                  style:
                  OutlinedButton.styleFrom(padding: EdgeInsets.all(2)),
                  onPressed: () => toClip(),
                  child: Icon(Icons.upload),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Import json from clipboard"),
                OutlinedButton(
                  style:
                  OutlinedButton.styleFrom(padding: EdgeInsets.all(2)),
                  onPressed: () => fromClip(),
                  child: Icon(Icons.download),
                ),
              ],
            ),
          ]),
        ));
  }
}

// Copies the stored data to the clipboard
void toClip() async {
  final Controller c = Get.find();
  ClipboardData data = ClipboardData(text: c.getJson());
  await Clipboard.setData(data);
}

// copies the data from clipboard to the saved data
void fromClip() async {
  final Controller c = Get.find();
  Clipboard.getData("text/plain").then((value) => {c.fromJson(value?.text)});
}