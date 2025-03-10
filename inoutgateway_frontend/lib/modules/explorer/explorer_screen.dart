import 'package:flutter/material.dart';
import 'package:inoutgateway_frontend/modules/explorer/assets_list_component.dart';
import 'package:inoutgateway_frontend/modules/explorer/storage_tree_component.dart';
import 'package:inoutgateway_frontend/modules/explorer/video_component.dart';

class ExplorerScreen extends StatefulWidget {
  const ExplorerScreen({super.key});

  @override
  State<ExplorerScreen> createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> {
  double centerWidth = 0.6;

  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double handlerWidth = 5;
    totalWidth -= handlerWidth;
    double leftColumnWidth = 250;
    double centerColumnWidth = totalWidth * centerWidth;
    double rightColumnWidth = totalWidth - (centerColumnWidth + leftColumnWidth);

    return Scaffold(
      body: Row(
        children: [
          // Left column (fixed width)
          SizedBox(width: leftColumnWidth, child: StorageTreeComponentWidget()),
          // Center column (resizable)
          SizedBox(width: centerColumnWidth, child: AssetsListComponentWidget()),
          // Resizable separator
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              setState(() {
                double delta = details.primaryDelta! / totalWidth;
                centerWidth = (centerWidth + delta).clamp(0.4, 0.6);
              });
            },
            child: MouseRegion(cursor: SystemMouseCursors.resizeLeftRight, child: Container(width: handlerWidth, color: Colors.black)),
          ),
          // Right column (resizable)
          SizedBox(width: rightColumnWidth, child: VideoComponentWidget()),
        ],
      ),
    );
  }
}
