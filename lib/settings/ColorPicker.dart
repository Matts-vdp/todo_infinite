import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/controller.dart';

class ColorPicker extends StatelessWidget {
  const ColorPicker({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.find();
    return Card(
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
                    ColorButton(color: i,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Used to create color selector buttons
class ColorButton extends StatelessWidget {
  const ColorButton({Key? key, required this.color,}) : super(key: key);
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

