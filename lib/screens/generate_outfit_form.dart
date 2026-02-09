import 'package:flutter/material.dart';
import '../models/clothing_item.dart';

class GenerateOutfitForm extends StatelessWidget {
  final List<ClothingItem> closet;
  final Map<ClothingType, ClothingItem?> outfit;
  final VoidCallback onGenerate;

  const GenerateOutfitForm({
    super.key,
    required this.closet,
    required this.outfit,
    required this.onGenerate,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Outfit Generator',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          Center(
            child: ElevatedButton.icon(
              onPressed: onGenerate,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Generate Outfit'),
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Result',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          if (outfit.isEmpty)
            const Text(
              'No outfit generated yet',
              style: TextStyle(color: Colors.grey),
            )
          else
            ...outfit.entries.map((e) {
              if (e.value == null) return const SizedBox();
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.checkroom),
                  title: Text(e.key.name),
                  subtitle: Text(e.value!.name),
                ),
              );
            }),
        ],
      ),
    );
  }
}
