import 'package:flutter/material.dart';

class CategoryForm extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;

  const CategoryForm({
    super.key,
    required this.controller,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Nama Kategori',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: onSubmit,
              child: const Text('Tambah'),
            ),
          ],
        ),
      ),
    );
  }
}
