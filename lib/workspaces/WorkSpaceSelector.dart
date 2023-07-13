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
    final Controller c = Get.find();
    String workspace;
    return Drawer(
        child: GetBuilder<Controller>(
          builder: (controller) =>
              ListView(
                children: [
                  WorkSpaceTitle(),
                  for (workspace in c.getWorkSpaces())
                    WorkSpace(workspace: workspace),
                  AddWorkSpace()
                ],
              ),)
    );
  }
}

class WorkSpace extends StatelessWidget {
  const WorkSpace({
    Key? key,
    required this.workspace,
  }) : super(key: key);
  final String workspace;

  void handlePressed(Controller c){
    c.switchToWorkSpace(workspace);
  }

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.find();
    return Card(
        child: MaterialButton(
            child: Text(workspace, textScaleFactor: 1.1),
            onPressed: () => handlePressed(c)
        )
    );
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
            child: Text("Workspaces",
            textScaleFactor: 1.3,)
        )
    );
  }
}
