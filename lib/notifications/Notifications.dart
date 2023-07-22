import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_infinite/components/actions/actions.dart';
import '../components/SyncIcon.dart';
import '../data/controllers/SettingsController.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../notifications/notification_service.dart' if (Platform.isAndroid) "";

// Provides the notification window
class Notifications extends StatefulWidget {
  const Notifications({ Key? key }) : super(key: key);
  @override
  _NotificationsState createState() => _NotificationsState();
}
class _NotificationsState extends State<Notifications> {
  final _formkey = GlobalKey<FormState>();
  final fieldText = TextEditingController();
  DateTime time = DateTime.now();

  void sendNotification(SettingsController settings, {bool sendNow = false}) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_formkey.currentState!.validate()) return;
    var text = fieldText.text;
    fieldText.clear();

    if (kIsWeb || !Platform.isAndroid) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Notifications are not possible on this device.')));
      fieldText.clear();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sending notification')));
    settings.incCnt();

    if (sendNow || time.isBefore(DateTime.now().add(Duration(seconds: 1))))
      NotificationService().send(text, "", settings.getCnt());
    else
      NotificationService().sendDelay(text, "", settings.getCnt(), time);
  }

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(33, 33, 33, 1),
        title: Text('Notifications'),
        actions: [
          SyncIcon(),
          HomeAction()
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              TextInputField(fieldText: fieldText),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Date: "+time.day.toString() + "/" + time.month.toString()),
                    OutlinedButton(
                        onPressed: () {
                          showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: 365))
                          ).then((value) {
                            if (value != null) {
                              setState(() {
                                time = DateTime(value.year, value.month, value.day, time.hour, time.minute);
                              });
                            }
                          });
                        },
                        child: Text("Pick date")
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Time: " + time.hour.toString() + ":" + time.minute.toString() + "h"),
                    OutlinedButton(
                        onPressed: () {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            builder: (BuildContext context, Widget? child) {
                              return MediaQuery(
                                data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                child: child!,
                              );
                            },
                          ).then((value) {
                            if (value != null) {
                              setState(() {
                                time = DateTime(time.year, time.month, time.day, value.hour, value.minute);
                              });
                            }
                          });
                        },
                        child: Text("Pick time")
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {sendNotification(settings, sendNow: true);},
                      child: Text("Send now"),
                    ),
                    SizedBox(width: 10,),
                    ElevatedButton(
                      onPressed: () {sendNotification(settings);},
                      child: Text("Send later"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextInputField extends StatelessWidget {
  const TextInputField({
    Key? key,
    required this.fieldText,
  }) : super(key: key);

  final TextEditingController fieldText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: fieldText,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Displayed text',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }
}



