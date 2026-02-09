import 'package:flutter/material.dart';
import '../models/clothing_item.dart';
import '../services/outfit_generator.dart';

import 'generate_outfit_form.dart';
import 'add_clothing_form.dart';
import 'closet_list_form.dart';

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
      imageBytes: null,
    ),
    ClothingItem(
      id: '2',
      name: 'Blue Jeans',
      type: ClothingType.bottom,
      colors: ['blue'],
      styles: ['casual'],
      imageBytes: null,
    ),
  ];

  Map<ClothingType, ClothingItem?> outfit = {};

  void generateOutfit() {
    setState(() {
      outfit = OutfitGenerator.generate(closet, 'casual');
    });
  }

  void addClothing(ClothingItem item) {
    setState(() {
      closet.add(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Closet'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.auto_awesome), text: 'Outfit'),
              Tab(icon: Icon(Icons.add), text: 'Add Clothes'),
              Tab(icon: Icon(Icons.list), text: 'Closet'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            GenerateOutfitForm(
              closet: closet,
              outfit: outfit,
              onGenerate: generateOutfit,
            ),
            AddClothingForm(
              onAdd: addClothing,
            ),
            ClosetListForm(
              closet: closet,
            ),
          ],
        ),
      ),
    );
  }
}
