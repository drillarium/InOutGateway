import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'shared/theme/theme_provider.dart';
import 'modules/auth/login_screen.dart';
import 'modules/home/home_screen.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (context) => ThemeProvider(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: "Flutter App",
          theme: themeProvider.themeData,
          initialRoute: "/",
          routes: {"/": (context) => LoginScreen(), "/home": (context) => HomeScreen()},
        );
      },
    );
  }
}
