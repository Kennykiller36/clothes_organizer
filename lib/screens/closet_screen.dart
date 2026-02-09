import 'package:flutter/material.dart';
import '../models/clothing_item.dart';
import '../services/outfit_generator.dart';
import 'add_clothing_dialog.dart';

class ClosetScreen extends StatefulWidget {
  @override
  State<ClosetScreen> createState() => _ClosetScreenState();
}

class _ClosetScreenState extends State<ClosetScreen> {
  final List<ClothingItem> closet = [
    ClothingItem(
      id: '1',
      name: 'Black Hoodie',
      type: ClothingType.top,
      colors: ['black'],
      styles: ['casual', 'street'],
    ),
    ClothingItem(
      id: '2',
      name: 'Blue Jeans',
      type: ClothingType.bottom,
      colors: ['blue'],
      styles: ['casual'],
    ),
    ClothingItem(
      id: '3',
      name: 'Sneakers',
      type: ClothingType.shoes,
      colors: ['white'],
      styles: ['casual', 'street'],
    ),
  ];

  Map<ClothingType, ClothingItem?> outfit = {};

  void generateOutfit() {
    setState(() {
      outfit = OutfitGenerator.generate(closet, 'casual');
    });
  }

  void openAddClothingDialog() async {
    final ClothingItem? newItem = await showDialog<ClothingItem>(
      context: context,
      builder: (_) => AddClothingDialog(),
    );

    if (newItem != null) {
      setState(() {
        closet.add(newItem);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Closet')),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: generateOutfit,
              child: const Text('Generate Outfit'),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: openAddClothingDialog,
              child: const Text('Add Clothing'),
            ),

            const SizedBox(height: 20),

            const Text(
              'Generated Outfit:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            ...outfit.entries.map((e) {
              if (e.value == null) return const SizedBox();
              return Text('${e.key.name}: ${e.value!.name}');
            }),

            const Divider(height: 32),

            const Text(
              'My Clothes:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: closet.length,
                itemBuilder: (context, index) {
                  final item = closet[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text(item.type.name),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
