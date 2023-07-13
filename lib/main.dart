import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_infinite/data/PersistedTodos.dart';
import 'package:todo_infinite/data/settings.dart';
import 'package:todo_infinite/data/trashData.dart';
import 'data/controller.dart';
import 'dart:io' show Platform;
import 'notifications/notification_service.dart' if (Platform.isAndroid) "";
import 'Data/file.dart';
import 'todo/TodoPage.dart';


void main() async {
  initializeNotifications();

  runApp(
      TodoInfinite(
        data: await initializeTodoData(),
        settingsData: await initializeSettings(),
        trashData: await initializeTrashData()
      )
  ); //use the stored data
}


class TodoInfinite extends StatelessWidget {
  final PersistedTodos data;
  final Settings settingsData;
  final TrashDataList trashData;
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

// Initialises the needed classes for notifications
Future<void> initializeNotifications() async{
  if (Platform.isAndroid) {
    WidgetsFlutterBinding.ensureInitialized();
    await NotificationService().init();
  }
}

Future<TrashDataList> initializeTrashData() async {
  var str = await readFile("trash.json");
  if (str.isEmpty) return TrashDataList();
  return TrashDataList.fromJson(jsonDecode(str));
}

Future<Settings> initializeSettings() async {
  var str = await readFile("settings.json");
  if (str.isEmpty) return Settings(1, 0, "", []);
  return Settings.fromJson(jsonDecode(str));
}

Future<PersistedTodos> initializeTodoData() async {
  var str = await readFile("data.json");
  if (str.isEmpty) return PersistedTodos(DateTime.now(), TodoData("To Do"));
  return PersistedTodos.fromJson(jsonDecode(str));
}
