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
  bool _isLoading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadCloset();
  }

  Future<void> _loadCloset() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });

    try {
      final loadedCloset = await StorageService.loadCloset();
      if (!mounted) return;
      setState(() {
        closet = loadedCloset;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _loadError =
            'Could not reach the server.\n'
            'Start the API after reboot, then tap Retry.\n\n'
            'Run: .\\start-dev.ps1';
      });
    }
  }

  void generateOutfit() {
    setState(() {
      outfit = OutfitGenerator.generate(closet, 'casual');
    });
  }

  Future<void> addClothing(ClothingItem item) async {
    setState(() => closet.add(item));

    try {
      await StorageService.saveCloset(closet);
    } catch (e) {
      if (!mounted) return;
      setState(() => closet.remove(item));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save clothing: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_loadError != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Closet')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_off, size: 48, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  _loadError!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _loadCloset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

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
