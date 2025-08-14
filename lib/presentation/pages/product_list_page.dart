import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerceapp/presentation/pages/sort_sheet.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../data/models/product.dart';
import '../viewmodels/admin_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../viewmodels/product_list_viewmodel.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});
  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ProductListViewModel>().load());
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductListViewModel>();
    final auth = context.watch<AuthViewModel>();

    return Column(
      children: [
        // Search bar + sort + admin button
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: vm.setSearch,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search products...',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.sort_rounded),
                onPressed: () async {
                  final s = await showModalBottomSheet(
                    context: context,
                    builder: (_) => const SortSheet(),
                  );
                  if (s != null) vm.setSort(s);
                },
              ),
              const SizedBox(width: 4),
              if (auth.isAdmin)
                FilledButton.icon(
                  onPressed: () => _openAddProduct(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
            ],
          ),
        ),

        // Categories row
        SizedBox(
          height: 44,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, i) {
              final cat = vm.categories[i];
              final selected = vm.category == cat;
              return ChoiceChip(
                label: Text(cat),
                selected: selected,
                onSelected: (_) => vm.setCategory(cat),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemCount: vm.categories.length,
          ),
        ),
        const SizedBox(height: 8),

        // Product grid

        // Inside your widget
        Expanded(
          child: LayoutBuilder(
            builder: (context, c) {
              final isWide = c.maxWidth > 700;
              final cross = isWide ? 4 : 2;
              final items = vm.products;

              if (items.isEmpty) {
                // Shimmer grid while loading
                return GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cross,
                    childAspectRatio: 0.50,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: cross * 2, // show 2 rows of shimmer
                  itemBuilder:
                      (_, i) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(color: Colors.white),
                      ),
                );
              }

              // Actual product grid
              return GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cross,
                  childAspectRatio: 0.50,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: items.length,
                itemBuilder: (_, i) => _ProductTile(product: items[i]),
              );
            },
          ),
        ),
      ],
    );
  }

  void _openAddProduct(BuildContext ctx) {
    final titleCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final catCtrl = TextEditingController(text: 'smartphones');
    final imgCtrl = TextEditingController(
      text: 'https://picsum.photos/seed/new/500/500',
    );

    showDialog(
      context: ctx,
      builder:
          (_) => AlertDialog(
            title: const Text('Add Product (Local)'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: priceCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Price'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: catCtrl,
                    decoration: const InputDecoration(labelText: 'Category'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: imgCtrl,
                    decoration: const InputDecoration(labelText: 'Image URL'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  final admin = context.read<AdminViewModel>();
                  final listVm = context.read<ProductListViewModel>();
                  final p = admin.createLocal(
                    title: titleCtrl.text.trim(),
                    price: double.tryParse(priceCtrl.text.trim()) ?? 0,
                    category: catCtrl.text.trim(),
                    imageUrl: imgCtrl.text.trim(),
                  );
                  listVm.addLocal(p);
                  Navigator.pop(ctx);
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  final ProductModel product;
  const _ProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartViewModel>();

    return GestureDetector(
      onTap: () => context.push('/product/${product.id}', extra: product),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Theme.of(context).dividerColor),
          color: Theme.of(context).cardColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Product Image
            Hero(
              tag: 'product-image-${product.id}',
              child: AspectRatio(
                aspectRatio: 1, // Square ratio for better product visibility
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(14),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: product.thumbnail,
                    fit: BoxFit.cover,
                    placeholder:
                        (c, _) => const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    errorWidget:
                        (c, _, __) => const Center(
                          child: Icon(Icons.broken_image_outlined, size: 40),
                        ),
                  ),
                ),
              ),
            ),

            /// Text + Button Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Product Title
                    Text(
                      product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),

                    /// Category
                    Text(
                      product.category,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 6),

                    /// Price
                    Text(
                      '₹ ${product.price.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                    const Spacer(),

                    /// Add to Cart Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(
                          Icons.add_shopping_cart_rounded,
                          size: 18,
                        ),
                        label: const Text('Add'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          textStyle: const TextStyle(fontSize: 14),
                        ),
                        onPressed: () {
                          cart.add(product);

                          // Show Snackbar

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      '${product.title} added to cart',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              backgroundColor:
                                  Colors.green.shade600, // Success green
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              margin: const EdgeInsets.all(12),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
