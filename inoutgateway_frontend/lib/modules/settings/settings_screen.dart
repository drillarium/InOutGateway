import 'package:flutter/material.dart';
import 'package:inoutgateway_frontend/modules/settings/node_component.dart';
import './preferences_component.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<SettingsScreen> {
  final List<String> _settingsListItems = ['Nodes', 'Sources', 'Routes', 'Transformers', 'Encoders', 'Mixers', 'Storages', 'Users', 'Preferences'];
  int _selectedSetting = 0;

  void _changeSeting(int index) {
    setState(() {
      _selectedSetting = index;
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
                    _settingsListItems.asMap().entries.map((item) {
                      return ListTile(
                        title: Text(
                          item.value,
                          style: TextStyle(
                            color: _selectedSetting == item.key ? Colors.blue : Colors.black,
                            fontWeight: _selectedSetting == item.key ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        onTap: () {
                          _changeSeting(item.key);
                          // Handle tap action for the left region item
                          print('$item clicked');
                        },
                      );
                    }).toList(),
              ),
            ),
          ),

          // Center Content (Inputs, Transformers, Outputs...)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_settingsListItems[_selectedSetting], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Divider(),
                  SizedBox(height: 20),
                  if (_selectedSetting == 0) NodeComponent(),
                  if (_selectedSetting == 8) PreferencesComponent(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
