import 'package:flutter/material.dart';

class PreferencesLicensingComponent extends StatelessWidget {
  final List<String> fieldLabels = [
    "License Key",
    "Activation Code",
    "Serial Number",
    "Product ID",
    "User Name",
    "Company",
    "Email",
    "Phone",
    "Expiration Date",
    "Notes",
  ];
  PreferencesLicensingComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Licensing", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              int columns = (constraints.maxWidth / 250).floor().clamp(1, 5); // Dynamically calculate columns
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children:
                    fieldLabels
                        .map((label) => SizedBox(width: constraints.maxWidth / columns - 16, child: TextField(decoration: InputDecoration(labelText: label))))
                        .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
