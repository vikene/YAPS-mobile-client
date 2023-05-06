import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:uuid/uuid.dart';
import 'package:yaps/Database/AssetRepository.dart';
import 'package:yaps/Exceptions/TitleNotFoundExceptions.dart';
import 'package:yaps/Models/AssetInformation.dart';
import '../Models/Asset.dart';

class LocalFileProcessingSTM {
  final int _pageCount = 30;
  late AssetRepository _assetRepository;

  Stream<Asset> scanAndFetchAssetInformation() async* {
    List<Asset> assets = List.empty();
    int page = 0;
    int count = await PhotoManager.getAssetCount();
    const uuid = Uuid();
    while (count > 0) {
      List<AssetEntity> entities = await PhotoManager.getAssetListPaged(
          page: page, pageCount: _pageCount);
      for (AssetEntity entity in entities) {
        var sha_256 = await _getSHAOfAsset(entity);
        Asset asset = Asset(
            GUID: uuid.v4(),
            AssetId: entity.id,
            Sha256: sha_256,
            LastUpdatedTime: DateTime.now().toUtc().toIso8601String());
        asset.assetInformation = await _getMetadataOfAsset(entity);
        yield asset;
      }
      count -= _pageCount;
      page += 1;
    }
  }

  Future<String> _getSHAOfAsset(AssetEntity assetEntity) async {
    File? file = await assetEntity.originFile;
    if (file == null) {
      throw Exception("SHA asset: File not found");
    }
    Stream<List<int>> readValue = file.openRead();
    Digest digest = await sha256.bind(readValue).first;
    print("Digest value $digest");
    return digest.toString();
  }

  Future<AssetInformation> _getMetadataOfAsset(AssetEntity assetEntity) async {
    String title = await _getTitleOfAsset(assetEntity);
    String type = assetEntity.type.name;
    int width = assetEntity.width;
    int height = assetEntity.height;
    bool isLive = assetEntity.isLivePhoto;
    double latitude = assetEntity.latitude!;
    double longitude = assetEntity.longitude!;
    String photoCreationTime = assetEntity.createDateTime.toIso8601String();
    return AssetInformation(
        GUID: "",
        Title: title,
        Type: type,
        Width: width,
        Height: height,
        IsLivePhoto: isLive,
        Latitude: latitude,
        Longitude: longitude,
        PhotoCreationTime: photoCreationTime);
  }

  Future<String> _getTitleOfAsset(AssetEntity assetEntity) async {
    String title = await assetEntity.titleAsync;
    if (title.isNotEmpty) {
      return title;
    }
    throw TitleNotFoundException(
        cause: "AssetTitle Not found ${assetEntity.id})");
  }
}
