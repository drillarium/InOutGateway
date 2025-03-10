import 'package:flutter/material.dart';
import 'package:inoutgateway_frontend/modules/alerts/alert_dialog_component.dart';
import '../../shared/constants.dart';
import '../../shared/session/user_session.dart';

class Header extends StatelessWidget {
  final Function(int) onSelectScreen;
  final int selectedScreen;

  const Header({super.key, required this.onSelectScreen, required this.selectedScreen});

  void _logout(BuildContext context) {
    UserSession().clearUserInfo();
    Navigator.pushReplacementNamed(context, "/");
  }

  // Helper function to build navigation buttons with selected app styling
  Widget _buildNavButton(int index, String label) {
    return TextButton(
      onPressed: () => onSelectScreen(index),
      child: Text(
        label,
        style: TextStyle(
          color: selectedScreen == index ? Colors.blue : Colors.black, // Change color for selected app
          fontWeight: selectedScreen == index ? FontWeight.bold : FontWeight.normal, // Bold for selected
        ),
      ),
    );
  }

  void _showAlertsDialog(BuildContext context, GlobalKey key) {
    final RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return AlertDialogComponent(buttonPosition: position);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Access logged user info from the global session
    final userSession = UserSession();
    String username = userSession.username;
    final GlobalKey notificationsKey = GlobalKey();
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Text("${AppConstants.appName} v${AppConstants.appVersion}", style: TextStyle(fontWeight: FontWeight.bold)),
          Spacer(),
          _buildNavButton(0, "Dashboard"),
          _buildNavButton(1, "Orchestrator"),
          _buildNavButton(2, "Explorer"),
          _buildNavButton(3, "Stats"),
          _buildNavButton(4, "Settings"),
          Spacer(),
          // Bell icon for alerts
          IconButton(icon: Icon(Icons.notifications), key: notificationsKey, onPressed: () => _showAlertsDialog(context, notificationsKey)),
          // Username behind logout button
          SizedBox(
            width: 120,
            child: Text(username.isNotEmpty ? username : '', textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 18)),
          ),
          TextButton(onPressed: () => _logout(context), child: Text("Logout", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}
