import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_infinite/planning/PlanningPage.dart';
import '../favorites/Favorites.dart';
import '../workspaces/WorkSpaceSelector.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
            children: [
              Pages(),
              SizedBox.fromSize(size: Size.fromHeight(30)),
              WorkSpaceSelector()
            ],
        ));
  }
}

class Pages extends StatelessWidget {
  const Pages({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          PagesTitle(),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
            child: FilledButton(
                onPressed: (){Get.to(() => Favorites());},
                child: Text("Favorites"),
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith((states) => Colors.amber),
                    foregroundColor: MaterialStateColor.resolveWith((states) => Colors.black87)
                ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
            child: FilledButton(
              onPressed: (){Get.to(() => PlanningPage());},
              child: Text("Planning"),
              style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blueGrey),
              ),
            ),
          )
        ]
    );
  }
}


class PagesTitle extends StatelessWidget {
  const PagesTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              "Pages",
              textScaleFactor: 1.3,
            )));
  }
}
