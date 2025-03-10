import 'package:flutter/material.dart';
import 'package:inoutgateway_frontend/shared/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class PreferencesConfigurationComponent extends StatelessWidget {
  const PreferencesConfigurationComponent({super.key});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Center(
      child: SwitchListTile(
        title: Text("Dark Mode"),
        value: themeProvider.themeData.brightness == Brightness.dark,
        onChanged: (value) {
          themeProvider.toggleTheme();
        },
      ),
    );
  }
}
