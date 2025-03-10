import 'package:flutter/material.dart';
import 'package:inoutgateway_frontend/modules/dashboard/dashboard_screen.dart';
import 'package:inoutgateway_frontend/modules/explorer/explorer_screen.dart';
import 'package:inoutgateway_frontend/modules/stats/stats_screen.dart';
import '../orchestrator/orchestrator_screen.dart';
import '../settings/settings_screen.dart';
import 'header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedScreen = 0;
  final List<Widget> _screens = [DashboardScreen(), OrchestratorScreen(), ExplorerScreen(), StatsScreen(), SettingsScreen()];

  void _changeScreen(int index) {
    setState(() {
      _selectedScreen = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(60), child: Header(onSelectScreen: _changeScreen, selectedScreen: _selectedScreen)),
      body: _screens[_selectedScreen],
    );
  }
}
