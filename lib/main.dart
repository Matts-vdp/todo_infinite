import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'data/controller.dart';
import 'dart:io' show Platform;
import 'notifications/notification_service.dart' if (Platform.isAndroid) "";
import 'Data/file.dart';
import 'todo/TodoPage.dart';

// Initialises the needed classes for notifications
Future<void> notif() async{
  if (Platform.isAndroid) {
    WidgetsFlutterBinding.ensureInitialized();
    await NotificationService().init();
  }
}

void main() async {
  notif();
  String data = await readFile("data.json"); //read previous stored data
  String settingsData = await readFile("settings.json");
  String trashData = await readFile("trash.json");
  runApp(TodoInfinite(data: data, settingsData: settingsData, trashData: trashData)); //use the stored data
}


// In charge of displaying the App
class TodoInfinite extends StatelessWidget {
  final String data;
  final String settingsData;
  final String trashData;
  const TodoInfinite({ Key? key, required  this.data, required this.settingsData, required this.trashData,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller(data, settingsData, trashData));
    return GetMaterialApp(
      title: 'Todo infinite',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSwatch(
          brightness: Brightness.dark,
          primarySwatch: c.getColors()[c.getColor()],
        ),
      ),
      themeMode: ThemeMode.light,
      home: TodoPage(arr:[]),
    );
  }
}






