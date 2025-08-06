import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService{
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    if(_prefs == null){
      _prefs = await SharedPreferences.getInstance();
    }
  }

  static Future<bool> setString(String key, String value)async{
    if(_prefs == null){
      throw AssertionError("SharedPreference belum di init. panggil fungsi SharedPreferenceService.init()");;
    }
    return await _prefs!.setString(key, value);
  }
  static String? getString(String key){
    if(_prefs == null){
      throw AssertionError("SharedPreference belum di init. panggil fungsi SharedPreferenceService.init()");;
    }
    return _prefs!.getString(key);
  }
}