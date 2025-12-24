import 'package:flutter/material.dart';
import '../core/supabase_client.dart';
import '../widgets/edit_product_dialog.dart';
import '../utils/export_csv.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();

  String? selectedCategory;

  Future<List> getCategories() async {
    return await supabase.from('categories').select();
  }

  Future<List> getProducts() async {
    return await supabase
        .from('products')
        .select('id, name, price, categories(name)')
        .order('name');
  }

  Future<void> addProduct() async {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        selectedCategory == null) return;

    await supabase.from('products').insert({
      'name': nameController.text,
      'price': int.parse(priceController.text),
      'category_id': selectedCategory,
    });

    nameController.clear();
    priceController.clear();
    setState(() {});
  }

  Future<void> deleteProduct(String id) async {
    await supabase.from('products').delete().eq('id', id);
    setState(() {});
  }

  void exportProducts(List products) {
    String csv = "Nama,Harga,Kategori\n";
    for (var p in products) {
      csv +=
          "${p['name']},${p['price']},${p['categories']['name']}\n";
    }
    exportCsv(csv);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Product Management',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          /// FORM INPUT
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: FutureBuilder(
                future: getCategories(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  final categories = snapshot.data as List;

                  return Column(
                    children: [
                      TextField(
                        controller: nameController,
                        decoration:
                            const InputDecoration(labelText: 'Nama Produk'),
                      ),
                      TextField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(labelText: 'Harga'),
                      ),
                      DropdownButtonFormField(
                        value: selectedCategory,
                        items: categories.map((c) {
                          return DropdownMenuItem(
                            value: c['id'],
                            child: Text(c['name']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value.toString();
                          });
                        },
                        decoration:
                            const InputDecoration(labelText: 'Kategori'),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: addProduct,
                        child: const Text('Tambah Produk'),
                      )
                    ],
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// EXPORT BUTTON
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.download),
              label: const Text('Export CSV'),
              onPressed: () async {
                final products = await getProducts();
                exportProducts(products);
              },
            ),
          ),

          const SizedBox(height: 10),

          /// TABLE DATA
          Expanded(
            child: FutureBuilder(
              future: getProducts(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                final products = snapshot.data as List;

                return DataTable(
                  columns: const [
                    DataColumn(label: Text('Nama')),
                    DataColumn(label: Text('Harga')),
                    DataColumn(label: Text('Kategori')),
                    DataColumn(label: Text('Aksi')),
                  ],
                  rows: products.map((p) {
                    return DataRow(cells: [
                      DataCell(Text(p['name'])),
                      DataCell(Text('Rp ${p['price']}')),
                      DataCell(Text(p['categories']['name'])),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Colors.blue),
                              onPressed: () async {
                                await showEditProductDialog(
                                    context, p);
                                setState(() {});
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.red),
                              onPressed: () =>
                                  deleteProduct(p['id']),
                            ),
                          ],
                        ),
                      ),
                    ]);
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
