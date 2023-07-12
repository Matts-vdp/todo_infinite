import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Data/controller.dart';

class SyncSettings extends StatefulWidget {
  const SyncSettings({Key? key}) : super(key: key);
  @override
  State<SyncSettings> createState() => _SyncSettingsState();
}

class _SyncSettingsState extends State<SyncSettings> {
  final _formkey = GlobalKey<FormState>();
  final fieldText = TextEditingController(text: Get.find<Controller>().getSyncKey());

  void post() async {
    final Controller c = Get.find();
    c.post(fieldText.text);
  }

  void fetch() async {
    final Controller c = Get.find();
    c.fetch(fieldText.text);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formkey,
        child: Row(
            children: [
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
            ]
        )
    );
  }
}
