class AssetInformation {
  String GUID;
  String? Title;
  String? Type;
  int? Width;
  int? Height;
  bool? IsLivePhoto;
  double? Latitude;
  double? Longitude;
  String? PhotoCreationTime;
  String? LastModifiedTime;
  String? BackupTime;
  String? LastAccessedTime;

  AssetInformation(
      {required this.GUID,
      this.Title,
      this.Type,
      this.Width,
      this.Height,
      this.IsLivePhoto,
      this.Latitude,
      this.Longitude,
      this.PhotoCreationTime,
      this.LastModifiedTime,
      this.BackupTime,
      this.LastAccessedTime});
}
