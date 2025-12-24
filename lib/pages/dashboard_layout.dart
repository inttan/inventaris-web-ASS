import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'dashboard_page.dart';
import 'category_page.dart';
import 'product_page.dart';
import 'login_page.dart';

class DashboardLayout extends StatefulWidget {
  const DashboardLayout({super.key});

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  int index = 0;

  final pages = const [
    DashboardPage(),
    CategoryPage(),
    ProductPage(),
  ];

  Future<void> logout(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Inventory Admin'),

        // 🔴 TOMBOL LOGOUT DI SINI
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: index,
            onDestinationSelected: (i) {
              setState(() => index = i);
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.category),
                label: Text('Category'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.shopping_bag),
                label: Text('Product'),
              ),
            ],
          ),
          Expanded(child: pages[index]),
        ],
      ),
    );
  }
}
