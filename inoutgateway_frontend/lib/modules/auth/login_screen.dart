import 'package:flutter/material.dart';
import 'package:inoutgateway_frontend/shared/session/user_session.dart';

import '../../shared/logger/logger_service.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController(text: "nrd");
  final TextEditingController _passwordController = TextEditingController(text: "nrd");

  LoginScreen({super.key});

  void _handleLogin(BuildContext context) {
    String username = _usernameController.text;

    // Assume successful login
    UserSession().setUserInfo(username: username, role: "User");

    LoggerService.log_("User $username logged in successfully", level: LogLevel.info);
    Navigator.pushReplacementNamed(context, "/home");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Login", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              TextField(controller: _usernameController, decoration: InputDecoration(labelText: "User")),
              TextField(controller: _passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
              SizedBox(height: 20),
              ElevatedButton(onPressed: () => _handleLogin(context), child: Text("Login")),
            ],
          ),
        ),
      ),
    );
  }
}
