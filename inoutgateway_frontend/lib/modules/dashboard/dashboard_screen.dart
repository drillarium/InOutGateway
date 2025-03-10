import 'package:flutter/material.dart';
import 'dashboard_component.dart'; // Import the custom component

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Sample data for the components
  final List<Map<String, String>> inputComponents = [
    {'name': 'Input 1', 'status': 'Active'},
    {'name': 'Input 2', 'status': 'Inactive'},
    {'name': 'Input 3', 'status': 'Active'},
    {'name': 'Input 4', 'status': 'Inactive'},
  ];

  final List<Map<String, String>> transformerComponents = [
    {'name': 'Transformer 1', 'status': 'Active'},
    {'name': 'Transformer 2', 'status': 'Inactive'},
    {'name': 'Transformer 3', 'status': 'Active'},
    {'name': 'Transformer 4', 'status': 'Inactive'},
  ];

  final List<Map<String, String>> outputComponents = [
    {'name': 'Output 1', 'status': 'Active'},
    {'name': 'Output 2', 'status': 'Inactive'},
    {'name': 'Output 3', 'status': 'Active'},
    {'name': 'Output 4', 'status': 'Inactive'},
  ];

  final List<Map<String, String>> encodersComponents = [
    {'name': 'Output 1', 'status': 'Active'},
    {'name': 'Output 2', 'status': 'Inactive'},
    {'name': 'Output 3', 'status': 'Active'},
    {'name': 'Output 4', 'status': 'Inactive'},
  ];

  final List<String> _nodeListItems = ['HOST#1', 'AWS#1', 'HOST#2'];
  int _selectedNode = 0;

  void _changeNode(int index) {
    setState(() {
      _selectedNode = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left region with the list of items
          Container(
            width: 200,
            color: Colors.grey[200],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children:
                    _nodeListItems.asMap().entries.map((item) {
                      return ListTile(
                        title: Text(
                          item.value,
                          style: TextStyle(
                            color: _selectedNode == item.key ? Colors.blue : Colors.black,
                            fontWeight: _selectedNode == item.key ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        onTap: () {
                          _changeNode(item.key);
                          // Handle tap action for the left region item
                          print('$item clicked');
                        },
                      );
                    }).toList(),
              ),
            ),
          ),

          // Right region with Inputs, Transformers, and Outputs
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // First Row - Inputs
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Inputs', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:
                              inputComponents.map((component) {
                                return DashboardComponentWidget(
                                  name: component['name']!,
                                  status: component['status']!,
                                  onTap: () {
                                    // Handle tap action
                                    print('${component['name']} clicked');
                                  },
                                );
                              }).toList(),
                        ),
                      ],
                    ),
                  ),

                  // Second Row - Transformers
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Transformers', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:
                              transformerComponents.map((component) {
                                return DashboardComponentWidget(
                                  name: component['name']!,
                                  status: component['status']!,
                                  onTap: () {
                                    // Handle tap action
                                    print('${component['name']} clicked');
                                  },
                                );
                              }).toList(),
                        ),
                      ],
                    ),
                  ),

                  // Third Row - Outputs
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Outputs', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:
                              outputComponents.map((component) {
                                return DashboardComponentWidget(
                                  name: component['name']!,
                                  status: component['status']!,
                                  onTap: () {
                                    // Handle tap action
                                    print('${component['name']} clicked');
                                  },
                                );
                              }).toList(),
                        ),
                      ],
                    ),
                  ),
                  // Fourth Row - Encoders
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Encoders', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:
                              encodersComponents.map((component) {
                                return DashboardComponentWidget(
                                  name: component['name']!,
                                  status: component['status']!,
                                  onTap: () {
                                    // Handle tap action
                                    print('${component['name']} clicked');
                                  },
                                );
                              }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
