import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';

import 'Database/AssetRepository.dart';
import 'Database/DatabaseHelper.dart';
import 'Workflows/LocalFilesProcessingSTM.dart';
import 'app.dart';

void _fetchMedia(RootIsolateToken token) async {
  BackgroundIsolateBinaryMessenger.ensureInitialized(token);
  DatabaseHelper databaseHelper = DatabaseHelper();
  databaseHelper.initDB().whenComplete(() async {
    print("DEBUG: Inside background thread Isolate!");
    AssetRepository assetRepository =
        AssetRepository.fromDatabase(databaseHelper);
    LocalFileProcessingSTM localFileProcessingSTM = LocalFileProcessingSTM();
    final PermissionState _ps = await PhotoManager.requestPermissionExtend();
    if (_ps.hasAccess) {
      print("Background compute has access");
      final int count = await PhotoManager.getAssetCount();
      await for (final asset
          in localFileProcessingSTM.scanAndFetchAssetInformation()) {
        await assetRepository.insertAsset(asset);
      }
      print("Number of assets in this device : $count");
    } else {
      print("Application failed to get photo access");
    }
  });
}

void main() async {
  var localFileProcessingSTM = LocalFileProcessingSTM();
  RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
  Isolate.spawn(_fetchMedia, rootIsolateToken);
  runApp(App());
}
