import 'package:get/get.dart';
import 'package:todo_infinite/data/WorkSpaces.dart';
import '../PersistedTodos.dart';
import '../persistence/httpsync.dart';
import 'TodoController.dart';

class WorkSpaceController extends GetxController {
  WorkSpaces workspaces;
  SyncState isSynced = SyncState.Unknown;

  WorkSpaceController(this.workspaces) {
    if (workspaces.syncKey.isNotEmpty)
      fetch();
  }

  Future<void> post() async {
    final TodoController c = Get.find<TodoController>();
    var status = await Sync.post(workspaces.syncKey, c.todo);
    isSynced = mapSyncStatus(status);
    update();
  }

  Future<SyncState> fetch({bool overwrite = false}) async {
    final TodoController c = Get.find<TodoController>();

    var result = await Sync.fetch(workspaces.syncKey);

    if (result.status == Status.Other)
      isSynced = SyncState.Unknown;
    else if (result.status == Status.Offline)
      isSynced = SyncState.Offline;
    else if (result.status == Status.Success) {
      var oldStatus = isSynced;
      var status = c.todo.compareLastMod(result.data!);
      if (status < 0) isSynced = SyncState.Outdated;
      if (status > 0) isSynced = SyncState.MoreRecent;
      if (status == 0) isSynced = SyncState.Synced;

      if (overwrite || isSynced == oldStatus) {
        await synchronize(result.data!, isSynced, c);
        isSynced = SyncState.Synced;
      }
    }
    update();
    return isSynced;
  }

  Future<void> synchronize(PersistedTodos result, SyncState status, TodoController c) async {
    if (status == SyncState.Synced) return;
    if (status == SyncState.Outdated) c.setTodo(result);
    if (status == SyncState.MoreRecent) await post();
  }

  Future<void> switchToWorkSpace(String key) async {
    final TodoController c = Get.find<TodoController>();
    setSyncKey(key);
    isSynced = SyncState.Unknown;
    await c.loadTodos(key);
    fetch();
    update();
  }

  void setSyncKey(String key){
    workspaces.syncKey = key;
    workspaces.save();
  }

  String getSyncKey(){
    return workspaces.syncKey;
  }

  List<String> getWorkSpaces(){
    return workspaces.workspaces;
  }

  void addWorkSpace(String workspace){
    if (workspaces.workspaces.contains(workspace)) return;

    workspaces.workspaces.add(workspace);
    workspaces.save();
    update();
  }

  void deleteWorkSpace(String workspace){
    if (!workspaces.workspaces.contains(workspace)) return;

    workspaces.workspaces.remove(workspace);
    workspaces.save();
    update();
  }

  void updateSyncState({bool doUpdate = false, bool setUnknown = false}){
    if (setUnknown) {
      isSynced = SyncState.Unknown;
      update();
      return;
    }

    if (isSynced == SyncState.Offline) return;
    if (isSynced == SyncState.Unknown) return;
    isSynced = SyncState.MoreRecent;

    if (doUpdate) update();
  }
}

enum SyncState {
  Unknown,
  Offline,
  Outdated,
  Synced,
  MoreRecent
}
SyncState mapSyncStatus(Status status) {
  switch (status) {
    case Status.Success: return SyncState.Synced;
    case Status.Offline: return SyncState.Offline;
  }
  return SyncState.Unknown;
}