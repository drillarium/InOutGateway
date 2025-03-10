import 'package:flutter/material.dart';
import 'package:inoutgateway_frontend/modules/stats/engine_stats.dart';
import 'package:inoutgateway_frontend/modules/stats/node_stats.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsComponentState();
}

class _StatsComponentState extends State<StatsScreen> {
  // Sample data structure: Nodes with running items
  final Map<String, List<Map<String, String>>> nodes = {
    "Node Group 1": [
      {"name": "Node A", "type": "node"},
      {"name": "Engine X", "type": "engine"},
    ],
    "Node Group 2": [
      {"name": "Node B", "type": "node"},
      {"name": "Engine Y", "type": "engine"},
    ],
  };

  String? selectedItem; // Currently selected running item
  String? selectedType; // type

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left Sidebar
        Container(
          width: 250,
          color: Colors.grey[200],
          child: ListView(
            children:
                nodes.keys.map((node) {
                  return ExpansionTile(
                    title: Text(node, style: TextStyle(fontWeight: FontWeight.bold)),
                    children:
                        nodes[node]!.map((item) {
                          return ListTile(
                            title: Text(item["name"]!),
                            subtitle: Text(item["type"]!, style: TextStyle(fontSize: 12, color: Colors.grey)),
                            onTap:
                                () => setState(() {
                                  selectedItem = item["name"]!;
                                  selectedType = item["type"]!;
                                }),
                          );
                        }).toList(),
                  );
                }).toList(),
          ),
        ),

        // Center Content (Stats for Selected Item)
        Expanded(
          child:
              selectedItem == null
                  ? Center(child: Text("Select an item to view stats"))
                  : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Stats for $selectedItem", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        SizedBox(height: 20),
                        selectedType == "node" ? NodeStatsComponent() : EngineStatsComponent(),
                      ],
                    ),
                  ),
        ),
      ],
    );
  }
}
