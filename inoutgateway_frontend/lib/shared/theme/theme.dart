import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    appBarTheme: AppBarTheme(backgroundColor: Colors.blue, titleTextStyle: TextStyle(color: Colors.white)),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    appBarTheme: AppBarTheme(backgroundColor: Colors.black, titleTextStyle: TextStyle(color: Colors.white)),
  );
}
