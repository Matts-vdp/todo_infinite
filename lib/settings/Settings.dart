import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:todo_infinite/syncIcon.dart';
import '../Data/controller.dart';
import '../components/SyncIcon.dart';
import 'ColorPicker.dart';
import 'SyncSettings.dart';

// Copies the stored data to the clipboard
void toClip() async{
  final Controller c = Get.find();
  ClipboardData data = ClipboardData(text: c.getJson());
  await Clipboard.setData(data);
}

// copies the data from clipboard to the saved data
void fromClip() async {
  final Controller c = Get.find();
  Clipboard.getData("text/plain").then((value) => {
    c.fromJson(value?.text)
  });
}

// Displays the settings tab
class Settings extends StatelessWidget {
  const Settings({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.find();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(33, 33, 33, 1),
        title: Text('Settings'),
        actions: [
          SyncIcon(),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Accent Color"),
                    SizedBox(height: 10,),
                    SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        runSpacing: 5,
                        direction: Axis.horizontal,
                        spacing: 5,
                        children: [
                          for (int i=0; i<c.getColors().length; i++)
                            ColorPicker(color: i,),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Export to clipboard as json"),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(padding: EdgeInsets.all(2)),
                      onPressed: () => toClip(),
                      child: Icon(Icons.upload),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Import json from clipboard"),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(padding: EdgeInsets.all(2)),
                      onPressed: () => fromClip(),
                      child: Icon(Icons.download),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SyncSettings()
              ),
            ),
          ],
        ),
      ),
    );
  }
}