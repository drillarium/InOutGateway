import 'package:flutter/material.dart';
import 'orchestrator_component.dart'; // Import the custom component

class OrchestratorScreen extends StatelessWidget {
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

  OrchestratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
                    children:
                        inputComponents.map((component) {
                          return OrchestratorComponentWidget(
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
                    children:
                        transformerComponents.map((component) {
                          return OrchestratorComponentWidget(
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
                    children:
                        outputComponents.map((component) {
                          return OrchestratorComponentWidget(
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
    );
  }
}
