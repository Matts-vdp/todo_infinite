import 'package:flutter/material.dart';
import '../components/SyncIcon.dart';
import 'ClipboardActions.dart';
import 'ColorPicker.dart';
import 'SyncSettings.dart';

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
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            ColorPicker(),
            ClipboardActions(),
            SyncSettings(),
          ],
        ),
      ),
    );
  }
}


