// responsible for keeping track of what the user last chose as a theme

import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences {
  static const prefKey = 'pref_key';

  setTheme(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(prefKey, value);
  }

  getTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(prefKey);
  }
}
