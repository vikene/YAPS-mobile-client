import 'package:yaps/Models/AssetInformation.dart';

class Asset {
  String GUID;
  String AssetId;
  String Sha256;
  String LastUpdatedTime;

  AssetInformation? assetInformation;

  Asset(
      {required this.GUID,
      required this.AssetId,
      required this.Sha256,
      required this.LastUpdatedTime});

  Asset.FromMap(Map<String, dynamic> res)
      : GUID = res["GUID"],
        AssetId = res["AssetId"],
        Sha256 = res["Sha256"],
        LastUpdatedTime = res["LastUpdatedTime"];

  Asset.FromAssetInformation(
      Map<String, dynamic> res, AssetInformation this.assetInformation)
      : GUID = res["GUID"],
        AssetId = res["AssetId"],
        Sha256 = res["Sha256"],
        LastUpdatedTime = res["LastUpdatedTime"];

  Map<String, Object?> toMap() {
    return {
      'GUID': GUID,
      'AssetId': AssetId,
      'Sha256': Sha256,
      'LastUpdatedTime': LastUpdatedTime
    };
  }
}
