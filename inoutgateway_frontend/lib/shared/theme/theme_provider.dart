import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inoutgateway_frontend/shared/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = AppThemes.lightTheme;
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  ThemeData get themeData => _themeData;

  void toggleTheme() async {
    if (_themeData.brightness == Brightness.dark) {
      _themeData = AppThemes.lightTheme;
      await _storage.write(key: "theme", value: "light");
    } else {
      _themeData = AppThemes.darkTheme;
      await _storage.write(key: "theme", value: "dark");
    }
    notifyListeners();
  }
}
