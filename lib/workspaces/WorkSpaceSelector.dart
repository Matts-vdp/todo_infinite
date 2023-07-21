import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/controller.dart';
import 'AddWorkSpace.dart';

class WorkSpaceSelector extends StatelessWidget {
  const WorkSpaceSelector({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String workspace;
    return Drawer(
        child: GetBuilder<Controller>(
          builder: (c) => ListView(
            children: [
              WorkSpaceTitle(),
              for (workspace in c.getWorkSpaces())
                WorkSpace(workspace: workspace, isCurrent: workspace == c.getSyncKey()),
              AddWorkSpace()
            ],
          ),
    ));
  }
}

class WorkSpace extends StatelessWidget {
  const WorkSpace({Key? key, required this.workspace, required this.isCurrent,}) : super(key: key);
  final String workspace;
  final bool isCurrent;

  void handlePressed(Controller c) {
    c.switchToWorkSpace(workspace);
  }

  void handleDismiss(Controller c) {
    c.deleteWorkSpace(workspace);
  }

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.find();
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Dismissible(
            key: Key(workspace),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) => Future.value(!isCurrent),
            onDismissed: (direction) => {handleDismiss(c)},
            child: Container(
                width: double.infinity,
                child:MaterialButton(
                color: Colors.white10,
                disabledColor: Colors.black26,
                disabledTextColor: Colors.white30,
                child: Text(workspace, textScaleFactor: 1.1),
                onPressed: isCurrent ? null : () => handlePressed(c))),

            background: Container(
                padding: EdgeInsets.all(10.0),
                width: double.infinity,
                color: Colors.red,
                child: Row(
                  children: [
                    Expanded(child: Container()),
                    Icon(Icons.delete)
                  ],
                )),
        ));
  }
}


class WorkSpaceTitle extends StatelessWidget {
  const WorkSpaceTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              "Workspaces",
              textScaleFactor: 1.3,
            )));
  }
}
