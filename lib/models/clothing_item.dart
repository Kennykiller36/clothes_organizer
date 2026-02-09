import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

enum ClothingType { top, bottom, shoes, outerwear }

class ClothingItem {
  final String id;
  final String name;
  final ClothingType type;
  final List<String> colors;
  final List<String> styles;
  final Uint8List? imageBytes;

  ClothingItem({
    required this.id,
    required this.name,
    required this.type,
    required this.colors,
    required this.styles,
    this.imageBytes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString().split('.').last,
      'colors': colors,
      'styles': styles,
      'imageBytes': imageBytes != null ? base64Encode(imageBytes!) : null,
    };
  }

  factory ClothingItem.fromJson(Map<String, dynamic> json) {
    return ClothingItem(
      id: json['id'],
      name: json['name'],
      type: ClothingType.values.firstWhere((e) => e.toString().split('.').last == json['type']),
      colors: List<String>.from(json['colors']),
      styles: List<String>.from(json['styles']),
      imageBytes: json['imageBytes'] != null ? base64Decode(json['imageBytes']) : null,
    );
  }
}
