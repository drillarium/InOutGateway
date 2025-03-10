import 'package:flutter/material.dart';

class StorageTreeComponentWidget extends StatelessWidget {
  const StorageTreeComponentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.grey[200], child: Column(children: [Text("Tree Structure"), Expanded(child: Placeholder())]));
  }
}
