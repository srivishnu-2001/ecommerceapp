import 'package:flutter/material.dart';

import '../viewmodels/product_list_viewmodel.dart';

class SortSheet extends StatelessWidget {
  const SortSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          const Text(
            'Sort by',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          ListTile(
            title: const Text('Popularity (Rating)'),
            onTap: () => Navigator.pop(context, SortBy.popularityDesc),
          ),
          ListTile(
            title: const Text('Price: Low to High'),
            onTap: () => Navigator.pop(context, SortBy.priceAsc),
          ),
          ListTile(
            title: const Text('Price: High to Low'),
            onTap: () => Navigator.pop(context, SortBy.priceDesc),
          ),
          ListTile(
            title: const Text('Name: A–Z'),
            onTap: () => Navigator.pop(context, SortBy.nameAsc),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
