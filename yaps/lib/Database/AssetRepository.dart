import 'package:sqflite/sqflite.dart';
import 'package:yaps/Database/DatabaseHelper.dart';
import 'package:yaps/Models/Asset.dart';

class AssetRepository {
  static AssetRepository _assetRepository = AssetRepository(db: null);

  late Database? db;
  AssetRepository({required this.db});

  factory AssetRepository.fromDatabase(DatabaseHelper dbHelper) {
    _assetRepository = AssetRepository(db: dbHelper.db);
    return _assetRepository;
  }

  Future<int> insertAsset(Asset asset) async {
    int result = await db!.insert('assets', asset.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
    return result;
  }

  Future<int> updateAsset(Asset asset) async {
    int result = await db!.update('assets', asset.toMap(),
        where: "GUID = ?", whereArgs: [asset.GUID]);
    return result;
  }

  Future<List<Asset>> fetchAssets() async {
    final List<Map<String, Object?>> queryResults = await db!.query('assets');
    return queryResults.map((e) => Asset.FromMap(e)).toList();
  }

  Future<Asset> fetchAsset(String GUID) async {
    List<Map<String, Object?>> queryResult =
        await db!.query('assets', where: "GUID = ?", whereArgs: [GUID]);
    return queryResult.map((e) => Asset.FromMap(e)).first;
  }

  Future<void> deleteUser(String GUID) async {
    await db!.delete("assets", where: "GUID = ?", whereArgs: [GUID]);
  }
}
