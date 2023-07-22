import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/controllers/WorkSpaceController.dart';

class SyncSettings extends StatefulWidget {
  const SyncSettings({Key? key}) : super(key: key);
  @override
  State<SyncSettings> createState() => _SyncSettingsState();
}

class _SyncSettingsState extends State<SyncSettings> {
  final _formkey = GlobalKey<FormState>();
  final fieldText = TextEditingController(text: Get.find<WorkSpaceController>().getSyncKey());

  void post() async {
    final c = Get.find<WorkSpaceController>();
    c.setSyncKey(fieldText.text);
    c.addWorkSpace(fieldText.text);
    c.post();
  }

  void fetch() async {
    final c = Get.find<WorkSpaceController>();
    c.setSyncKey(fieldText.text);
    c.addWorkSpace(fieldText.text);
    c.fetch(overwrite: true);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Form(
                key: _formkey,
                child: Row(children: [
                  Expanded(
                    child: TextFormField(
                      controller: fieldText,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Key',
                      ),
                    ),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(padding: EdgeInsets.all(2)),
                    onPressed: () => post(),
                    child: Icon(Icons.upload),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(padding: EdgeInsets.all(2)),
                    onPressed: () => fetch(),
                    child: Icon(Icons.download),
                  ),
                ]))));
  }
}
