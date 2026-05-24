import 'dart:convert';
import 'dart:typed_data';

enum ClothingType { top, bottom, shoes, outerwear }

class ClothingItem {
  final String id;
  final String name;
  final ClothingType type;
  final List<String> colors;
  final List<String> styles;
  final bool hasImage;
  final Uint8List? imageBytes;

  ClothingItem({
    required this.id,
    required this.name,
    required this.type,
    required this.colors,
    required this.styles,
    this.hasImage = false,
    this.imageBytes,
  });

  ClothingItem copyWith({
    String? id,
    String? name,
    ClothingType? type,
    List<String>? colors,
    List<String>? styles,
    bool? hasImage,
    Uint8List? imageBytes,
  }) {
    return ClothingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      colors: colors ?? this.colors,
      styles: styles ?? this.styles,
      hasImage: hasImage ?? this.hasImage,
      imageBytes: imageBytes ?? this.imageBytes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString().split('.').last,
      'colors': colors,
      'styles': styles,
      'hasImage': hasImage || imageBytes != null,
      'imageBytes': imageBytes != null ? base64Encode(imageBytes!) : null,
    };
  }

  static Uint8List? decodeImageBytes(dynamic value) {
    if (value == null || value is! String || value.isEmpty) return null;
    try {
      return base64Decode(value);
    } catch (_) {
      return null;
    }
  }

  factory ClothingItem.fromJson(Map<String, dynamic> json) {
    return ClothingItem(
      id: json['id'],
      name: json['name'],
      type: ClothingType.values.firstWhere((e) => e.toString().split('.').last == json['type']),
      colors: List<String>.from(json['colors']),
      styles: List<String>.from(json['styles']),
      hasImage: json['hasImage'] == true || json['imageBytes'] != null,
      imageBytes: decodeImageBytes(json['imageBytes']),
    );
  }
}
