enum ClothingType { top, bottom, shoes, outerwear }

class ClothingItem {
  final String id;
  final String name;
  final ClothingType type;
  final List<String> colors;
  final List<String> styles;

  ClothingItem({
    required this.id,
    required this.name,
    required this.type,
    required this.colors,
    required this.styles,
  });
}
