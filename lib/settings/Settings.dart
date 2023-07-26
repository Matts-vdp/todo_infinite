import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_infinite/data/controllers/TodoController.dart';
import '../components/SyncIcon.dart';
import '../components/actions/actions.dart';
import 'ClipboardActions.dart';
import 'ColorPicker.dart';
import 'SyncSettings.dart';
import 'TagSettings.dart';

// Displays the settings tab
class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(33, 33, 33, 1),
        title: Text('Settings'),
        actions: [
          SyncIcon(),
          TrashAction(),
          HomeAction()
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            ColorPicker(),
            ClipboardActions(),
            SyncSettings(),
            BackupSettings(),
            TagSettings()
          ],
        ),
      ),
    );
  }
}

class BackupSettings extends StatelessWidget {
  const BackupSettings({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ElevatedButton(
              child: Text("Restore backup"),
              onPressed: (){handlePressed();},
          ),
        ));
  }

  void handlePressed() {
    final todo = Get.find<TodoController>();
    todo.restoreBackup();
  }
}