class UserSession {
  // Singleton pattern to ensure only one instance
  static final UserSession _instance = UserSession._internal();

  factory UserSession() {
    return _instance;
  }

  UserSession._internal();

  // User properties
  String username = '';
  String role = '';
  bool isLoggedIn = false;

  // Method to set user info
  void setUserInfo({required String username, required String role}) {
    this.username = username;
    this.role = role;
    isLoggedIn = true;
  }

  // Method to clear user info when logging out
  void clearUserInfo() {
    username = '';
    role = '';
    isLoggedIn = false;
  }
}
