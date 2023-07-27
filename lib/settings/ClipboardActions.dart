import 'package:flutter/material.dart';
import '../data/persistence/clipboard.dart';


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