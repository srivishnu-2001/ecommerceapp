import 'package:ecommerceapp/data/models/user.dart';
import 'package:ecommerceapp/presentation/pages/order_list_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/auth_viewmodel.dart';
import 'cart_page.dart';
import 'product_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int idx = 0;
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deals for you'),
        actions: [
          Row(
            children: [
              const Text('User'),
              Switch(
                value:
                    context
                        .watch<AuthViewModel>()
                        .isAdmin, // watch for role changes
                onChanged: (isAdmin) async {
                  final auth = context.read<AuthViewModel>();

                  // Toggle role for any logged-in user
                  await auth.setRole(isAdmin ? UserRole.admin : UserRole.user);

                  // Feedback
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isAdmin ? 'Admin mode active' : 'User mode active',
                      ),
                    ),
                  );
                },
              ),

              const Text('Admin'),
              const SizedBox(width: 8),
            ],
          ),
          IconButton(
            onPressed: () => setState(() => idx = 1),
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),

      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child:
            idx == 0
                ? const ProductListPage()
                : idx == 1
                ? const CartPage()
                : const OrderListPage(),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                title: Text('Logged in: ${auth.current?.name ?? '-'}'),
                subtitle: Text(auth.isAdmin ? 'Admin' : 'User'),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  auth.logout(context);
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx,
        onDestinationSelected: (i) => setState(() => idx = i),
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            label: 'Shop',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'my orders',
          ),
        ],
      ),
    );
  }
}
