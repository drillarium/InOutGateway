import 'package:flutter/material.dart';
import './preferences_licensing.dart';
import './preferences_configuration.dart';

class PreferencesComponent extends StatelessWidget {
  const PreferencesComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(tabs: [Tab(text: "Configuration"), Tab(text: "Licensing")]),
          SizedBox(height: 300, child: TabBarView(children: [PreferencesConfigurationComponent(), PreferencesLicensingComponent()])),
        ],
      ),
    );
  }
}
