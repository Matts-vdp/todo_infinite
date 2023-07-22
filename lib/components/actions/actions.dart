import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../notifications/Notifications.dart';
import '../../settings/Settings.dart';
import '../../todo/TodoPage.dart';
import '../../trash/Trash.dart';


class NotificationAction extends StatelessWidget {
  const NotificationAction({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Get.to(() => Notifications());
      },
      icon: Icon(
        Icons.notifications_none_rounded,
      ),
    );
  }
}

class TrashAction extends StatelessWidget {
  const TrashAction({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Get.to(() => Trash());
      },
      icon: Icon(
        Icons.delete_outline,
      ),
    );
  }
}

class SettingsAction extends StatelessWidget {
  const SettingsAction({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Get.to(() => Settings());
      },
      icon: Icon(
        Icons.settings,
      ),
    );
  }
}

class HomeAction extends StatelessWidget {
  const HomeAction({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        debugPrint("test");
        Get.offAll(() => TodoPage(arr: []));
      },
      icon: Icon(Icons.home),
    );
  }
}