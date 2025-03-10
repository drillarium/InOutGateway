import 'package:flutter/material.dart';

class NodeStatsComponent extends StatelessWidget {
  const NodeStatsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Metric 1: 85%", style: TextStyle(fontSize: 18)),
        Text("Metric 2: 120ms", style: TextStyle(fontSize: 18)),
        Text("Metric 3: Running", style: TextStyle(fontSize: 18, color: Colors.green)),
      ],
    );
  }
}
