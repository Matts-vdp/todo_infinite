import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_infinite/data/WorkSpaces.dart';
import '../data/PersistedTodos.dart';
import '../data/settings.dart';
import '../data/trashData.dart';
import 'dart:io' show Platform;
import 'data/Tags.dart';
import 'data/controllers/TagsController.dart';
import 'notifications/notification_service.dart' if (Platform.isAndroid) "";
import 'data/persistence/persistence.dart';
import 'todo/TodoPage.dart';
import 'data/controllers/SettingsController.dart';
import 'data/controllers/TodoController.dart';
import 'data/controllers/TrashController.dart';
import 'data/controllers/WorkSpaceController.dart';


void main() async {
  await registerDependencies();

  runApp(TodoInfinite());
}


class TodoInfinite extends StatelessWidget {
  const TodoInfinite({ Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = Get.find<SettingsController>();

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

Future<void> registerDependencies() async {
  initializeNotifications();
  var settings = await initializeSettings();
  var workspaces = await initializeWorkSpaces();
  var todos = await initializeTodoData(workspaces.syncKey);
  var trashDataList = await initializeTrashData();
  var tags = await initializeTagsData();

  Get.put(TodoController(todos));
  Get.put(SettingsController(settings));
  Get.put(WorkSpaceController(workspaces));
  Get.put(TrashController(trashDataList));
  Get.put(TagsController(tags));
}

// Initialises the needed classes for notifications
Future<void> initializeNotifications() async{
  if (Platform.isAndroid) {
    WidgetsFlutterBinding.ensureInitialized();
    await NotificationService().init();
  }
}

Future<TrashDataList> initializeTrashData() async {
  var str = await readFromPersistence("trash.json");
  if (str.isEmpty) return TrashDataList();
  return TrashDataList.fromJson(jsonDecode(str));
}

Future<WorkSpaces> initializeWorkSpaces() async {
  var str = await readFromPersistence("workspaces.json");
  if (str.isEmpty) return WorkSpaces("", []);
  return WorkSpaces.fromJson(jsonDecode(str));
}

Future<Settings> initializeSettings() async {
  var str = await readFromPersistence("settings.json");
  if (str.isEmpty) return Settings(1, 0);
  return Settings.fromJson(jsonDecode(str));
}

Future<Tags> initializeTagsData() async{
  var str = await readFromPersistence("tags.json");
  if (str.isEmpty) return Tags([]);
  return Tags.fromJson(jsonDecode(str));
}

Future<PersistedTodos> initializeTodoData(String key) async {
  return readTodosFromFile(key);
}
