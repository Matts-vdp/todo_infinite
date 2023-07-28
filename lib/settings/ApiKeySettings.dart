import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/controllers/WorkSpaceController.dart';

class ApiKeySettings extends StatefulWidget {
  const ApiKeySettings({Key? key}) : super(key: key);
  @override
  State<ApiKeySettings> createState() => _ApiKeySettingsState();
}

class _ApiKeySettingsState extends State<ApiKeySettings> {
  final _formkey = GlobalKey<FormState>();
  final fieldText = TextEditingController(text: Get.find<WorkSpaceController>().getApiKey());

  void handleClick() async {
    final c = Get.find<WorkSpaceController>();
    c.setApiKey(fieldText.text);
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
                        labelText: 'Api key',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => handleClick(),
                    child: Icon(Icons.done),
                  ),
                ]))));
  }
}
