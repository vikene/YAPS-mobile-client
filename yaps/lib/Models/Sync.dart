class Sync {
  String GUID;
  bool Synced;
  bool ExistsInLocal;
  String LastBackupTime;

  Sync(
      {required this.GUID,
      required this.Synced,
      required this.ExistsInLocal,
      required this.LastBackupTime});

  Sync.FromMap(Map<String, dynamic> res)
      : GUID = res["GUID"],
        Synced = res["Synced"],
        ExistsInLocal = res["ExistsInLocal"],
        LastBackupTime = res["LastBackupTime"];

  Map<String, Object>? toMap() {
    return {
      'GUID': GUID,
      'Synced': Synced,
      'ExistsInLocal': ExistsInLocal,
      'LastBackupTime': LastBackupTime
    };
  }
}
