import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static SharedPreferencesManager? instance;
  static SharedPreferences? preferences;

  static Future<SharedPreferencesManager> getInstance() async {
    if (instance == null) {
      instance = SharedPreferencesManager();
    }
    if (preferences == null) {
      preferences = await SharedPreferences.getInstance();
    }
    return instance!;
  }

  // Keys for shared preferences
  static const String isLoggedInKey = 'isLoggedIn';
  static const String userEmailKey = 'userEmail';
  static const String isTrainerAccountKey = 'isTrainerAccount'; // New key


  // Getters and setters for shared preferences

  bool get isLoggedIn => preferences!.getBool(isLoggedInKey) ?? false;

  set isLoggedIn(bool value) {
    preferences!.setBool(isLoggedInKey, value);
  }

  String get userEmail => preferences!.getString(userEmailKey) ?? '';

  set userEmail(String value) {
    preferences!.setString(userEmailKey, value);
  }
  bool get isTrainerAccount => preferences?.getBool(isTrainerAccountKey) ?? false;

  set isTrainerAccount(bool value) {
    preferences?.setBool(isTrainerAccountKey, value);
  }
}
