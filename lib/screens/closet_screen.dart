import 'package:flutter/material.dart';
import '../models/clothing_item.dart';
import '../services/outfit_generator.dart';
import '../services/storage_service.dart';

import 'generate_outfit_form.dart';
import 'add_clothing_form.dart';
import 'closet_list_form.dart';

class ClosetScreen extends StatefulWidget {
  @override
  State<ClosetScreen> createState() => _ClosetScreenState();
}

class _ClosetScreenState extends State<ClosetScreen> {
  List<ClothingItem> closet = [];

  Map<ClothingType, ClothingItem?> outfit = {};

  @override
  void initState() {
    super.initState();
    _loadCloset();
  }

  Future<void> _loadCloset() async {
    final loadedCloset = await StorageService.loadCloset();
    setState(() {
      closet = loadedCloset;
    });
  }

  void generateOutfit() {
    setState(() {
      outfit = OutfitGenerator.generate(closet, 'casual');
    });
  }

  void addClothing(ClothingItem item) async {
    setState(() {
      closet.add(item);
    });
    await StorageService.saveCloset(closet);
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
