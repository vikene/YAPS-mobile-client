import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _databaseHelper = DatabaseHelper._();

  DatabaseHelper._();

  late Database db;

  factory DatabaseHelper() {
    return _databaseHelper;
  }

  Future<void> initDB() async {
    String path = await getDatabasesPath();

    db = await openDatabase(join(path, 'yaps.db'),
        onCreate: (db, version) async {
      await db.execute("""
      CREATE TABLE assets (
        GUID STRING PRIMARY KEY,
        AssetId STRING NOT NULL,
        Sha256 STRING NOT NULL,
        LastUpdatedTime STRING,
        UNIQUE(Sha256)
      )
    """);
      await db.execute("""
    CREATE TABLE syncs (
      GUID STRING NOT NULL,
      Synced INTEGER NOT NULL,
      ExistsInLocal INTEGER NOT NULL,
      LastBackupTime STRING,
      PRIMARY KEY (GUID),
      FOREIGN KEY (GUID) REFERENCES assets (GUID)
    );
""");

      await db.execute("""
      CREATE TABLE cloudfilelocation (
        GUID STRING NOT NULL,
        ThumbnailLocation STRING,
        SourceLocation STRING,
        PRIMARY KEY (GUID),
        FOREIGN KEY (GUID) REFERENCES assets (GUID)
      )
""");
    }, onConfigure: (db) async {
      await db.execute("PRAGMA foreign_keys = ON");
    }, version: 2);
  }
}
