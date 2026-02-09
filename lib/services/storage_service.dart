import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/clothing_item.dart';

class StorageService {
  static const String _closetFileName = 'closet.json';

  static Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$_closetFileName';
  }

  static Future<void> saveCloset(List<ClothingItem> closet) async {
    final filePath = await _getFilePath();
    final file = File(filePath);
    final jsonList = closet.map((item) => item.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await file.writeAsString(jsonString);
  }

  static Future<List<ClothingItem>> loadCloset() async {
    try {
      final filePath = await _getFilePath();
      final file = File(filePath);
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final jsonList = jsonDecode(jsonString) as List<dynamic>;
        return jsonList.map((json) => ClothingItem.fromJson(json)).toList();
      }
    } catch (e) {
      // Handle errors, e.g., file not found or corrupted
      print('Error loading closet: $e');
    }
    return [];
  }
}
