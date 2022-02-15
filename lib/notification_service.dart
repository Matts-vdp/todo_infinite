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
    //Currently not needed
  }

  Future<void> sendGroup() async {
    const String groupKey = 'com.android.todo-infinite.GROUP';
    const String groupChannelId = 'group';
    const String groupChannelName = 'group';
    AndroidNotificationDetails androidPlatformChannelSpecifics = 
    AndroidNotificationDetails(
        groupChannelId,   
        groupChannelName, 
        groupChannelName, 
        importance: Importance.max,
        priority: Priority.high,
        visibility: NotificationVisibility.private,
        playSound: true,
        enableVibration: true,
        groupKey: groupKey,
        setAsGroupSummary: true,
        autoCancel: false,
    );

    NotificationDetails platformChannelSpecifics = 
  NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(0, "Todo's", "", platformChannelSpecifics);
  }

  void sendnotif(String title, String body, int id) async {
    const String groupKey = 'com.android.todo-infinite.GROUP';
    const String groupChannelId = 'group';
    const String groupChannelName = 'group';
    AndroidNotificationDetails androidPlatformChannelSpecifics = 
    AndroidNotificationDetails(
        groupChannelId,   
        groupChannelName, 
        groupChannelName, 
        importance: Importance.max,
        priority: Priority.high,
        visibility: NotificationVisibility.private,
        playSound: true,
        enableVibration: true,
        groupKey: groupKey,
        autoCancel: false,
    );

    NotificationDetails platformChannelSpecifics = 
  NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(id, title, body, platformChannelSpecifics);
  }

  // used to send a notification with given title and body
  void send(String title, String body, int id) async{
    sendGroup().then((value) {
      sendnotif(title, body, id);
    });
    
  }
   
}