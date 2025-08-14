import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerceapp/presentation/pages/check_out_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/cart_viewmodel.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartViewModel>();

    if (cart.items.isEmpty) {
      return const Center(child: Text('Your cart is empty'));
    }

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: cart.items.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (c, i) {
              final item = cart.items[i];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),

                /// Product Image
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: item.product.thumbnail,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) => const SizedBox(
                          width: 60,
                          height: 60,
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                    errorWidget:
                        (context, url, error) =>
                            const Icon(Icons.broken_image, size: 40),
                  ),
                ),

                title: Text(
                  item.product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Text('₹ ${item.product.price.toStringAsFixed(0)}'),

                /// Quantity controls
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed:
                          () => cart.changeQty(item.product, item.qty - 1),
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text('${item.qty}'),
                    IconButton(
                      onPressed:
                          () => cart.changeQty(item.product, item.qty + 1),
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                    IconButton(
                      onPressed: () => cart.remove(item.product),
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        /// Total + Checkout
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                'Total: ₹ ${cart.total.toStringAsFixed(0)}',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CheckoutPage()),
                  );
                },
                child: const Text('Checkout'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
