import 'package:flutter_local_notifications/flutter_local_notifications.dart'; 

// handles the sending of notifications
class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  
  Future<void> init() async{
    final AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('icon');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid, 
            iOS: null, 
            macOS: null);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
 
  }
  Future selectNotification(String? payload) async {
    //Currently nor needed
  }

  // used to send a notification with given title and body
  void send(String title, String body) async{
    AndroidNotificationDetails androidPlatformChannelSpecifics = 
    AndroidNotificationDetails(
        "String",   
        "String", 
        "String", 
        importance: Importance.max,
        priority: Priority.high,
        visibility: NotificationVisibility.private,
        playSound: true,
        enableVibration: true,
    );

    NotificationDetails platformChannelSpecifics = 
  NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(0, title, body, platformChannelSpecifics);
  }
   
}