import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/controller.dart';

// Used to create color selector buttons
class ColorPicker extends StatelessWidget {
  const ColorPicker({Key? key, required this.color,}) : super(key: key);
  final int color;
  @override
  Widget build(BuildContext context) {
    final Controller c = Get.find();
    return SizedBox(
      width: 50,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(2),
          backgroundColor: c.getColors()[color],
        ),
        onPressed: () {
          c.setColor(color);
        },
        child: Container(),
      ),
    );
  }
}

