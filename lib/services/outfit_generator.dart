import '../models/clothing_item.dart';
import 'dart:math';

class OutfitGenerator {
  static Map<ClothingType, ClothingItem?> generate(
    List<ClothingItem> clothes,
    String style,
  ) {
    final random = Random();

    ClothingItem? pick(ClothingType type) {
      // First, try to pick items that match the style
      var filtered = clothes.where((c) =>
        c.type == type && c.styles.contains(style)
      ).toList();

      // If no items match the style, pick any item of that type
      if (filtered.isEmpty) {
        filtered = clothes.where((c) => c.type == type).toList();
      }

      if (filtered.isEmpty) return null;
      return filtered[random.nextInt(filtered.length)];
    }

    return {
      ClothingType.top: pick(ClothingType.top),
      ClothingType.bottom: pick(ClothingType.bottom),
      ClothingType.shoes: pick(ClothingType.shoes),
      ClothingType.outerwear: pick(ClothingType.outerwear),
    };
  }
}
