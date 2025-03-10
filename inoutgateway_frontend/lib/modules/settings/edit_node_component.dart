import 'package:flutter/material.dart';

class EditNodeComponent extends StatelessWidget {
  final VoidCallback onClose;
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
  EditNodeComponent({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(icon: Icon(Icons.arrow_back), onPressed: onClose),
              SizedBox(width: 8),
              Text("Node#1", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Spacer(),
              ElevatedButton(onPressed: () {}, child: Text("Save")),
            ],
          ),
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
