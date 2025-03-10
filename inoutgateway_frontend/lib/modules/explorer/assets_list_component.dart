import 'package:flutter/material.dart';

class AssetsListComponentWidget extends StatelessWidget {
  const AssetsListComponentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.blue[100], child: Column(children: [Text("Thumbnails"), Expanded(child: Placeholder())]));
  }
}
