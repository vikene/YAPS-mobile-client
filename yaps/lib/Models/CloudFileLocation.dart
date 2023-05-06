class CloudFileLocation {
  String GUID;
  String ThumbnailLocation;
  String SourceLocation;

  CloudFileLocation(
      {required this.GUID,
      required this.ThumbnailLocation,
      required this.SourceLocation});

  CloudFileLocation.FromMap(Map<String, dynamic> res)
      : GUID = res["GUID"],
        ThumbnailLocation = res["ThumbnailLocation"],
        SourceLocation = res["SourceLocation"];

  Map<String, Object>? toMap() {
    return {
      'GUID': GUID,
      'ThumbnailLocation': ThumbnailLocation,
      'SourceLocation': SourceLocation
    };
  }
}
