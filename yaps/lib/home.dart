import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';
import 'package:yaps/Database/AssetRepository.dart';
import 'package:yaps/Database/DatabaseHelper.dart';
import 'package:yaps/Models/Asset.dart';
import 'package:yaps/Workflows/LocalFilesProcessingSTM.dart';

class GridDisplay extends StatefulWidget {
  const GridDisplay({super.key});

  @override
  State<GridDisplay> createState() => _GridDisplayState();
}

class _GridDisplayState extends State<GridDisplay> {
  int numberOfAssets = 0;
  int currentPage = 0;
  int? lastPage;
  List<Widget> items = List.empty();
  late DatabaseHelper dbHelper;
  late AssetRepository assetRepository;
  late LocalFileProcessingSTM localFileProcessingSTM;
  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    dbHelper.initDB().whenComplete(() async {
      print("Database initialized");
      assetRepository = AssetRepository.fromDatabase(dbHelper);
      await _populateData();
    });
  }

  _handleScrollEvents(ScrollNotification scrollNotification) {
    if (scrollNotification.metrics.pixels /
            scrollNotification.metrics.maxScrollExtent >
        0.33) {
      if (lastPage != currentPage) {
        _populateData();
      }
    }
  }

  Future<String> _fetchMediaDigest(AssetEntity assetEntity) async {
    File? file = await assetEntity.originFile;
    if (file != null) {
      Stream<List<int>> readValue = file.openRead();
      Digest digest = await sha256.bind(readValue).first;
      print("Digest value $digest");
      var uuid = Uuid();
      Asset asset = Asset(
          GUID: uuid.v4(),
          AssetId: assetEntity.id,
          Sha256: digest.toString(),
          LastUpdatedTime: DateTime.now().toIso8601String());
      int result = await assetRepository.insertAsset(asset);
      print("Result of insert " + result.toString());
      return digest.toString();
    }
    return "";
  }

  Future<void> _populateData() async {
    List<Asset> assets = await assetRepository.fetchAssets();
    List<Widget> temp = [];
    for (var asset in assets) {
      AssetEntity? imageAsset = await AssetEntity.fromId(asset.AssetId);
      if (imageAsset != null) {
        temp.add(FutureBuilder(
          future: imageAsset.thumbnailDataWithSize(ThumbnailSize(200, 200)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Container(
                  child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.memory(
                      snapshot.data!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ));
            }
            return Container();
          },
        ));
      }
    }

    setState(() {
      items = temp;
      numberOfAssets = temp.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: numberOfAssets,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (BuildContext context, int index) {
          if (index < items.length) {
            return GestureDetector(
              child: items[index],
              onTap: () => {context.go("/checkpermissions")},
            );
          }
        });
  }
}
