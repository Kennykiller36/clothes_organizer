import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../models/clothing_item.dart';

const int _maxImageEdge = 1024;

class AddClothingForm extends StatefulWidget {
  final void Function(ClothingItem item) onAdd;

  const AddClothingForm({super.key, required this.onAdd});

  @override
  State<AddClothingForm> createState() => _AddClothingFormState();
}

class _AddClothingFormState extends State<AddClothingForm> {
  final TextEditingController nameController = TextEditingController();
  ClothingType selectedType = ClothingType.top;
  final TextEditingController colorsController = TextEditingController();
  final TextEditingController stylesController = TextEditingController();
  Uint8List? imageBytes;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: _maxImageEdge.toDouble(),
      maxHeight: _maxImageEdge.toDouble(),
      imageQuality: 85,
    );
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        imageBytes = bytes;
      });
    }
  }

  void saveClothing() {
    if (nameController.text.isEmpty) return;

    final newItem = ClothingItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: nameController.text,
      type: selectedType,
      colors: colorsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      styles: stylesController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      hasImage: imageBytes != null,
      imageBytes: imageBytes,
    );

    widget.onAdd(newItem);

    // reset form
    nameController.clear();
    colorsController.clear();
    stylesController.clear();
    setState(() {
      selectedType = ClothingType.top;
      imageBytes = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Clothing added')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add Clothing',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          DropdownButtonFormField<ClothingType>(
            value: selectedType,
            decoration: const InputDecoration(
              labelText: 'Type',
              border: OutlineInputBorder(),
            ),
            items: ClothingType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type.name),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedType = value;
                });
              }
            },
          ),

          const SizedBox(height: 12),

          TextField(
            controller: colorsController,
            decoration: const InputDecoration(
              labelText: 'Colors (comma separated)',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: stylesController,
            decoration: const InputDecoration(
              labelText: 'Styles (comma separated)',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),
          Center(
            child: ElevatedButton.icon(
              onPressed: pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Pick Image'),
            ),
          ),
          if (imageBytes != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  imageBytes!,
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                  cacheWidth: 256,
                  cacheHeight: 256,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, size: 48),
                ),
              ),
            ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: saveClothing,
              child: const Text('Save Clothing'),
            ),
          ),
        ],
      ),
    );
  }
}
