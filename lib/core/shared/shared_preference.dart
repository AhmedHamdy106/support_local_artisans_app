import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPreference {
  static late SharedPreferences sharedPreferences;

  // Initialization method
  static Future<SharedPreferences> init() async {
    return sharedPreferences = await SharedPreferences.getInstance();
  }

  // Method to save data of different types
  static Future<bool> saveData({required String key, required dynamic value}) async {
    if (value is int) {
      return sharedPreferences.setInt(key, value);
    } else if (value is String) {
      return sharedPreferences.setString(key, value);
    } else if (value is double) {
      return sharedPreferences.setDouble(key, value);
    } else if (value is List<String>) {
      return sharedPreferences.setStringList(key, value);
    } else if (value is bool) {
      return sharedPreferences.setBool(key, value);
    } else if (value is Map) {
      String jsonString = jsonEncode(value); // Encode map to JSON string
      return sharedPreferences.setString(key, jsonString);
    } else {
      throw Exception("Unsupported data type");
    }
  }

  // Method to get data based on the type
  static dynamic getData({required String key}) {
    var value = sharedPreferences.get(key);

    // Check if the data is a JSON string and decode it
    if (value is String) {
      try {
        return jsonDecode(value); // Try to decode JSON
      } catch (e) {
        return value; // If not JSON, return the string itself
      }
    }
    return value;
  }

  // Method to remove data
  static Future<bool> removeData({required String key}) async {
    return await sharedPreferences.remove(key);
  }

  // Method to check if a key exists in SharedPreferences
  static bool containsKey({required String key}) {
    return sharedPreferences.containsKey(key);
  }
}