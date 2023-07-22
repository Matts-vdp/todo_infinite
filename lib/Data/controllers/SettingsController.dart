import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../settings.dart';

class SettingsController extends GetxController {
  Settings settings;

  SettingsController(this.settings);

  int getCnt() {
    return settings.cnt;
  }

  void incCnt() {
    settings.cnt++;
    settings.save();
  }

  List<MaterialColor> getColors(){
    return Settings.colors;
  }

  MaterialColor currentColor(){
    return getColors()[getColor()];
  }

  int getColor(){
    return settings.color;
  }

  void setColor(int c){
    settings.color = c;
    Get.changeTheme(
        ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSwatch(
            brightness: Brightness.dark,
            primarySwatch: Settings.colors[c],
          ),
        )
    );
    update();
    settings.save();
  }
}