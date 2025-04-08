import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  static const token = 'TOKEN';

  Future<String> get getToken async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(token) ?? '';
  }

  void setToken(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(token, value);
  }
}
