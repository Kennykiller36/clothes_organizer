import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/clothing_item.dart';

class StorageService {
  static Future<void> saveCloset(List<ClothingItem> closet) async {
    final body = jsonEncode(closet.map((item) => item.toJson()).toList());
    final response = await http.put(
      ApiConfig.closetUri(),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save closet (${response.statusCode})');
    }
  }

  static Future<List<ClothingItem>> loadCloset() async {
    final response = await http.get(ApiConfig.closetUri());

    if (response.statusCode != 200) {
      throw Exception('Failed to load closet (${response.statusCode})');
    }

    final jsonList = jsonDecode(response.body) as List<dynamic>;
    return jsonList
        .map((json) => ClothingItem.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
