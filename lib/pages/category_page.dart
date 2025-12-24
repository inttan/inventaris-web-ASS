import 'package:flutter/material.dart';
import '../core/supabase_client.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final controller = TextEditingController();

  Future<List> getCategories() async {
    return await supabase.from('categories').select().order('name');
  }

  Future<void> addCategory() async {
    if (controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama kategori tidak boleh kosong')),
      );
      return;
    }

    await supabase.from('categories').insert({
      'name': controller.text.trim(),
    });

    controller.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kategori berhasil ditambahkan')),
    );

    setState(() {});
  }

  Future<void> deleteCategory(String id) async {
    await supabase.from('categories').delete().eq('id', id);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kategori dihapus')),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Categories',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          /// INPUT
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: 'Nama Kategori',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: addCategory,
                child: const Text('Add'),
              )
            ],
          ),

          const SizedBox(height: 30),

          /// LIST CATEGORY
          Expanded(
            child: FutureBuilder(
              future: getCategories(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final categories = snapshot.data as List;

                if (categories.isEmpty) {
                  return const Center(child: Text('Belum ada kategori'));
                }

                return ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final c = categories[index];

                    return Card(
                      child: ListTile(
                        title: Text(c['name']),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteCategory(c['id']),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
