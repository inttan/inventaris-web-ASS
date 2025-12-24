import 'package:flutter/material.dart';
import '../core/supabase_client.dart';
import '../widgets/stat_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  Future<Map<String, dynamic>> loadStats() async {
    final products = await supabase.from('products').select();
    final categories = await supabase.from('categories').select();

    int totalValue = 0;
    for (var p in products) {
      totalValue += (p['price'] as int);
    }

    return {
      'products': products.length,
      'categories': categories.length,
      'totalValue': totalValue,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: FutureBuilder(
        future: loadStats(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          final data = snapshot.data as Map<String, dynamic>;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Dashboard',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  StatCard(
                    title: 'Total Produk',
                    value: data['products'].toString(),
                    icon: Icons.inventory,
                  ),
                  StatCard(
                    title: 'Total Kategori',
                    value: data['categories'].toString(),
                    icon: Icons.category,
                  ),
                  StatCard(
                    title: 'Total Nilai Barang',
                    value: 'Rp ${data['totalValue']}',
                    icon: Icons.monetization_on,
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
