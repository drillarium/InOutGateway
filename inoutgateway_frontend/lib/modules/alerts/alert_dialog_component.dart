import 'package:flutter/material.dart';

class AlertDialogComponent extends StatelessWidget {
  final Offset buttonPosition; // Bell icon position
  final List<Map<String, dynamic>> alerts = [
    {"icon": Icons.warning, "color": Colors.orange, "title": "Low storage space", "subtitle": "Check your storage settings"},
    {"icon": Icons.error, "color": Colors.red, "title": "Server disconnected", "subtitle": "Reconnect to continue"},
    {"icon": Icons.info, "color": Colors.blue, "title": "New update available", "subtitle": "Version 1.2.3 is now available"},
  ];

  AlertDialogComponent({super.key, required this.buttonPosition});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Close when tapping outside
        GestureDetector(onTap: () => Navigator.of(context).pop(), child: Container(color: Colors.transparent, width: double.infinity, height: double.infinity)),

        // Alert Box Positioned below the bell icon
        Positioned(
          left: buttonPosition.dx - 125, // Adjust to align below the button
          top: buttonPosition.dy + 40, // Position below the button
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 300,
              height: MediaQuery.of(context).size.height - 200,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Padding(padding: const EdgeInsets.all(10), child: Text("Alerts", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                  Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: alerts.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Icon(alerts[index]["icon"], color: alerts[index]["color"]),
                          title: Text(alerts[index]["title"]),
                          subtitle: Text(alerts[index]["subtitle"]),
                        );
                      },
                    ),
                  ),
                  Divider(),
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("Close")),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
