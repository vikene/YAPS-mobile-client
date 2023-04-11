import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';

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

  @override
  void initState() {
    super.initState();
    _fetchMedia();
  }

  _handleScrollEvents(ScrollNotification scrollNotification) {
    if (scrollNotification.metrics.pixels /
            scrollNotification.metrics.maxScrollExtent >
        0.33) {
      if (lastPage != currentPage) {
        _fetchMedia();
      }
    }
  }

  void _fetchMedia() async {
    lastPage = currentPage;
    final PermissionState _ps = await PhotoManager.requestPermissionExtend();
    if (_ps.hasAccess) {
      print("Application has access");
      final int count = await PhotoManager.getAssetCount();
      setState(() {
        numberOfAssets = count;
      });
      final List<AssetEntity> entities = await PhotoManager.getAssetListPaged(
          page: 0, pageCount: numberOfAssets);

      List<Widget> temp = [];
      for (var asset in entities) {
        temp.add(FutureBuilder(
          future: asset.thumbnailDataWithSize(ThumbnailSize(200, 200)),
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

        setState(() {
          items = temp;
          currentPage += 1;
        });
      }
      print("Number of assets in this device : $count");
    } else {
      print("Application failed to get photo access");
    }
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
