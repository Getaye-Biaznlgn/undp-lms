import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static final AppPreferences _instance = AppPreferences._internal();

  factory AppPreferences() {
    return _instance;
  }

  AppPreferences._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<bool> saveString(String key, String value) async {
    return _prefs!.setString(key, value);
  }
  // save user type
  Future<bool> saveUserId(String userId) async {
    return _prefs!.setString('userId', userId);
  }
  //read user type
  String? getUserId() {
    return _prefs!.getString('userId');
  }
  //delete user type
  Future<bool> deleteUserId() async {
    return _prefs!.remove('userId');
  }
  //save token
  Future<bool> saveToken(String token) async {
    return _prefs!.setString('token', token);
  }
  //read token
  String? getToken() {
    return _prefs!.getString('token');
  }
  //delete token
  Future<bool> deleteToken() async {
    return _prefs!.remove('token');
  }
  //read token
  Future<String?> readString(String key) async {
    return _prefs!.getString(key);
  }

  Future<bool> deleteString(String key) async {
    return _prefs!.remove(key);
  }

  Future<bool> saveBool(String key, bool value) async {
    return _prefs!.setBool(key, value);
  }

  Future<bool?> readBool(String key) async {
    return _prefs!.getBool(key);
  }

  Future<bool> deleteBool(String key) async {
    return _prefs!.remove(key);
  }
  Future<bool> clear() async{
    deleteUserId();
    deleteToken();
  return   _prefs!.clear();
  }


}
