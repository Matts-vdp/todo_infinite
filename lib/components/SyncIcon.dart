import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/controller.dart';

class SyncIcon extends StatelessWidget {
  const SyncIcon({Key? key}) : super(key: key);

  Future<void> handlePressed(Controller c) async {
    await c.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Controller>(builder: (todo)=>
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: IconButton(
            icon: Icon(
              getIcon(todo.isSynced),
              color: getColor(todo.isSynced)),
            onPressed: () => handlePressed(todo)
          )
        )
    );
  }

  IconData getIcon(SyncState status){
    switch (status){
      case SyncState.Unknown: return Icons.sync_problem;
      case SyncState.Outdated: return Icons.download;
      case SyncState.Synced: return Icons.cloud_sync;
      case SyncState.MoreRecent: return Icons.upload;
    }
  }

  Color getColor(SyncState status) {
    switch (status){
      case SyncState.Unknown: return Colors.orange;
      case SyncState.Outdated: return Colors.red;
      case SyncState.Synced: return Colors.green;
      case SyncState.MoreRecent: return Colors.blue;
    }
  }
}