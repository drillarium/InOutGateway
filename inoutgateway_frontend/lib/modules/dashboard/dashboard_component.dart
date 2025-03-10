import 'package:flutter/material.dart';

class DashboardComponentWidget extends StatelessWidget {
  final String name;
  final String status;
  final void Function()? onTap; // Callback function when the component is tapped

  const DashboardComponentWidget({required this.name, required this.status, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    Icon icon;
    Color color;

    // Set icon and color based on status
    if (status == 'Active') {
      icon = Icon(Icons.check_circle, color: Colors.green);
      color = Colors.green.shade100;
    } else {
      icon = Icon(Icons.error, color: Colors.red);
      color = Colors.red.shade100;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150, // Fixed width for square
        height: 150, // Fixed height for square
        margin: EdgeInsets.symmetric(horizontal: 8), // Spacing between components
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            SizedBox(height: 10),
            Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(status, style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: status == 'Active' ? Colors.green : Colors.red)),
          ],
        ),
      ),
    );
  }
}
