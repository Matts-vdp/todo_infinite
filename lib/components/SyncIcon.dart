import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/controllers/WorkSpaceController.dart';

class SyncIcon extends StatelessWidget {
  const SyncIcon({Key? key}) : super(key: key);

  Future<void> handlePressed(WorkSpaceController c) async {
    await c.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WorkSpaceController>(builder: (todo)=>
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
      case SyncState.Unknown: return Icons.sync_outlined;
      case SyncState.Outdated: return Icons.download;
      case SyncState.Synced: return Icons.cloud_sync;
      case SyncState.MoreRecent: return Icons.upload;
      case SyncState.Offline: return Icons.cloud_off;
    }
  }

  Color getColor(SyncState status) {
    switch (status){
      case SyncState.Unknown: return Colors.orange;
      case SyncState.Outdated: return Colors.yellow;
      case SyncState.Offline: return Colors.white24;
      case SyncState.Synced: return Colors.green;
      case SyncState.MoreRecent: return Colors.blue;
    }
  }
}