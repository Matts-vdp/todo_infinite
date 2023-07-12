import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Data/controller.dart';
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
  @override
  Widget build(BuildContext context) {
    final Controller c = Get.find();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(33, 33, 33, 1),
        title: Text('Notifications'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              TextFormField(
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
              ),
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
                              lastDate: DateTime.now().add(Duration(days: 365)))
                              .then((value) {
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
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (_formkey.currentState!.validate()) {
                          if (!kIsWeb && Platform.isAndroid){ //notifications dont work on versions other then android
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sending notification...')));
                            c.incCnt();
                            NotificationService().send(fieldText.text, "", c.getCnt());
                          }
                          else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Notifications are not possible on this device.')));
                          }
                          fieldText.clear();
                        }
                      },
                      child: Text("Send now"),
                    ),
                    SizedBox(width: 10,),
                    ElevatedButton(
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (_formkey.currentState!.validate()) {
                          if (!kIsWeb && Platform.isAndroid){ //notifications dont work on versions other then android
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sending notification...')));
                            c.incCnt();
                            if (time.isAfter(DateTime.now().add(Duration(seconds: 1)))) {
                              NotificationService().sendDelay(fieldText.text, "", c.getCnt(), time);
                            }
                            else {
                              NotificationService().send(fieldText.text, "", c.getCnt());
                            }
                          }
                          else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Notifications are not possible on this device.')));
                          }
                          fieldText.clear();
                        }
                      },
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



