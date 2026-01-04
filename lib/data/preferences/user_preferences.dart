import 'package:shared_preferences/shared_preferences.dart';
import '../../model/user.dart';

class UserPreference {
  static const _keyUserId = 'user_id';
  static const _keyName = 'user_name';
  static const _keyEmail = 'user_email';

  // Save user info in SharedPreferences
  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, user.userId);
    await prefs.setString(_keyName, user.name);
    await prefs.setString(_keyEmail, user.email);
  }

  // Get current user from SharedPreferences
  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(_keyUserId);
    final name = prefs.getString(_keyName);
    final email = prefs.getString(_keyEmail);

    // password should not stored inside the share preferences
    if (userId != null && name != null && email != null) {
      return User(
        userId: userId,
        name: name,
        email: email,
        password: '', 
      );
    }
    return null;
  }

  // Clear user info (on logout)
  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyName);
    await prefs.remove(_keyEmail);
  }
}