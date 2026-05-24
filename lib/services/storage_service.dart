import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/clothing_item.dart';

class StorageService {
  static Uri _itemImageUri(String id) =>
      Uri.parse('${ApiConfig.baseUrl}/closet/items/$id/image');

  static Future<void> saveItem(ClothingItem item) async {
    final response = await http
        .post(
          Uri.parse('${ApiConfig.baseUrl}/closet/items'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(item.toJson()),
        )
        .timeout(const Duration(seconds: 60));

    if (response.statusCode != 201) {
      throw Exception('Failed to save item (${response.statusCode})');
    }
  }

  static Future<List<ClothingItem>> loadCloset() async {
    final response = await http
        .get(ApiConfig.closetUri())
        .timeout(const Duration(seconds: 30));

    if (response.statusCode != 200) {
      throw Exception('Failed to load closet (${response.statusCode})');
    }

    final jsonList = jsonDecode(response.body) as List<dynamic>;
    return jsonList
        .map((json) => ClothingItem.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  static Future<Uint8List?> loadItemImage(String id) async {
    final response = await http
        .get(_itemImageUri(id))
        .timeout(const Duration(seconds: 60));

    if (response.statusCode == 404) return null;
    if (response.statusCode != 200) {
      throw Exception('Failed to load image (${response.statusCode})');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return ClothingItem.decodeImageBytes(json['imageBytes']);
  }
}
