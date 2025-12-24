import 'package:flutter/material.dart';
import '../core/supabase_client.dart';

Future<void> showEditProductDialog(
  BuildContext context,
  Map product,
) async {
  final name = TextEditingController(text: product['name']);
  final price = TextEditingController(text: product['price'].toString());

  await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Edit Produk'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: name, decoration: const InputDecoration(labelText: 'Nama')),
          TextField(controller: price, keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Harga')),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
        ElevatedButton(
          onPressed: () async {
            await supabase.from('products').update({
              'name': name.text,
              'price': int.parse(price.text),
            }).eq('id', product['id']);
            Navigator.pop(context);
          },
          child: const Text('Simpan'),
        )
      ],
    ),
  );
}
