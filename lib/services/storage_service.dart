import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;
import '../models/clothing_item.dart';

class StorageService {
  static const String _closetKey = 'closet';

  static Future<void> saveCloset(List<ClothingItem> closet) async {
    final jsonList = closet.map((item) => item.toJson()).toList();
    final jsonString = jsonEncode(jsonList);

    if (kIsWeb) {
      html.window.localStorage[_closetKey] = jsonString;
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_closetKey, jsonString);
    }
    print('Closet saved with ${closet.length} items');
  }

  static Future<List<ClothingItem>> loadCloset() async {
    try {
      String? jsonString;
      if (kIsWeb) {
        jsonString = html.window.localStorage[_closetKey];
      } else {
        final prefs = await SharedPreferences.getInstance();
        jsonString = prefs.getString(_closetKey);
      }

      if (jsonString != null) {
        final jsonList = jsonDecode(jsonString) as List<dynamic>;
        final items = jsonList.map((json) => ClothingItem.fromJson(json)).toList();
        print('Closet loaded with ${items.length} items');
        return items;
      } else {
        print('No closet data found');
      }
    } catch (e) {
      // Handle errors, e.g., corrupted data
      print('Error loading closet: $e');
    }
    return [];
  }
}
