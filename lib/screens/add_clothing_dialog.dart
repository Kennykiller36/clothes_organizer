import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../models/clothing_item.dart';

class AddClothingDialog extends StatefulWidget {
  @override
  _AddClothingDialogState createState() => _AddClothingDialogState();
}

class _AddClothingDialogState extends State<AddClothingDialog> {
  final TextEditingController nameController = TextEditingController();
  ClothingType selectedType = ClothingType.top;
  final TextEditingController colorsController = TextEditingController();
  final TextEditingController stylesController = TextEditingController();
  Uint8List? imageBytes;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
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
      colors: colorsController.text.split(',').map((e) => e.trim()).toList(),
      styles: stylesController.text.split(',').map((e) => e.trim()).toList(),
      imageBytes: imageBytes,
    );

    Navigator.pop(context, newItem);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add Clothing',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),

              const SizedBox(height: 12),

              DropdownButtonFormField<ClothingType>(
                value: selectedType,
                decoration: const InputDecoration(labelText: 'Type'),
                items: ClothingType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedType = value!;
                  });
                },
              ),

              const SizedBox(height: 12),

              TextField(
                controller: colorsController,
                decoration: const InputDecoration(labelText: 'Colors (comma separated)'),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: stylesController,
                decoration: const InputDecoration(labelText: 'Styles (comma separated)'),
              ),

              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: pickImage,
                child: const Text('Pick Image'),
              ),

              if (imageBytes != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Image.memory(
                    imageBytes!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),

              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: saveClothing,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
