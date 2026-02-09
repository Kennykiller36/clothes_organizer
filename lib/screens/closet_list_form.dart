import 'package:flutter/material.dart';
import '../models/clothing_item.dart';

class ClosetListForm extends StatelessWidget {
  final List<ClothingItem> closet;

  const ClosetListForm({
    super.key,
    required this.closet,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'My Clothes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child: closet.isEmpty
                ? const Center(
                    child: Text(
                      'No clothes added yet',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: closet.length,
                    itemBuilder: (context, index) {
                      final item = closet[index];
                      return Card(
                        child: ListTile(
                          leading: item.imageBytes != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.memory(
                                    item.imageBytes!,
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(Icons.checkroom),
                          title: Text(item.name),
                          subtitle: Text(item.type.name),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
