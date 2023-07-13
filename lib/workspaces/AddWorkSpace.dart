import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/controller.dart';


class AddWorkSpace extends StatefulWidget {
  const AddWorkSpace({
    Key? key,
  }) : super(key: key);

  @override
  State<AddWorkSpace> createState() => _AddWorkSpaceState();
}

class _AddWorkSpaceState extends State<AddWorkSpace> {
  final fieldText = TextEditingController();

  // used when the add button is pressed
  void submitText(String str, Controller c) {
    if (str.isEmpty) return;
    c.addWorkSpace(str);
    fieldText.clear();
  }

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.find();

    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: fieldText,
              decoration: InputDecoration(
                labelStyle: TextStyle(fontSize: 14),
                labelText: 'New workspace',
              ),
              onSubmitted: (String val) => submitText(val, c),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          SizedBox(
            height: 40,
            width: 40,
            child: OutlinedButton(
                style: ElevatedButton.styleFrom(padding: EdgeInsets.all(2)),
                onPressed: () => submitText(fieldText.text, c),
                child: Icon(Icons.add)),
          ),
        ],
      ),
    );
  }
}