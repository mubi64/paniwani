import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  String prefKeyLoginData = 'prefKeyLoginData';
  String prefKeyEmployeeData = 'prefKeyEmployeeData';
  String prefKeyToken = 'prefKeyToken';
  String prefUserName = 'prefUserName';
  String prefPassword = 'prefPassword';
  String prefBaseUrl = 'prefBaseUrl';

  readObject(String? key) async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(key!);
    if (data == null) {
      return null;
    }
    var decode = json.decode(data);
    if (decode != null) {
      return decode;
    } else {
      return null;
    }
  }

  saveObject(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  Future<String> readString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '';
  }

  saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  readInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  saveInt(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  Future<bool> containKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }
}
