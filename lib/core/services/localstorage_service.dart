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
  Future<bool> saveUserType(String userType) async {
    return _prefs!.setString('userType', userType);
  }
  //read user type
  String? getUserType() {
    return _prefs!.getString('userType');
  }
  //delete user type
  Future<bool> deleteUserType() async {
    return _prefs!.remove('userType');
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
    deleteUserType();
    deleteToken();
  return   _prefs!.clear();
  }


}
