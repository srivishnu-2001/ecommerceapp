import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../viewmodels/cart_viewmodel.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout'), centerTitle: true),
      body:
          cart.items.isEmpty
              ? const Center(child: Text('Your cart is empty'))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Delivery Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInputCard(_nameCtrl, 'Full Name', Icons.person),
                    const SizedBox(height: 12),
                    _buildInputCard(
                      _addressCtrl,
                      'Address',
                      Icons.home,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12),
                    _buildInputCard(
                      _phoneCtrl,
                      'Phone Number',
                      Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Order Summary',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...cart.items.map(
                      (item) => Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(item.product.title),
                          subtitle: Text(
                            '₹${item.product.price} x ${item.qty}',
                          ),
                          trailing: Text(
                            '₹${(item.product.price * item.qty).toStringAsFixed(0)}',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Total: ₹${cart.total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton(
                        onPressed: () => _placeOrder(cart),
                        child: const Text(
                          'Place Order',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildInputCard(
    TextEditingController controller,
    String label,
    IconData icon, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            icon: Icon(icon, color: Colors.grey[700]),
            border: InputBorder.none,
            labelText: label,
          ),
        ),
      ),
    );
  }

  Future<void> _placeOrder(CartViewModel cart) async {
    if (_nameCtrl.text.isEmpty ||
        _addressCtrl.text.isEmpty ||
        _phoneCtrl.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Your cart is empty')));
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final ordersJson = prefs.getStringList('orders') ?? [];

    final order = {
      'name': _nameCtrl.text.trim(),
      'address': _addressCtrl.text.trim(),
      'phone': _phoneCtrl.text.trim(),
      'items':
          cart.items
              .map(
                (item) => {
                  'title': item.product.title,
                  'price': item.product.price,
                  'qty': item.qty,
                  'subtotal': (item.product.price * item.qty),
                },
              )
              .toList(),
      'total': cart.total,
      'date': DateTime.now().toIso8601String(),
    };

    ordersJson.add(jsonEncode(order));
    await prefs.setStringList('orders', ordersJson);

    // Clear cart
    // cart.clear();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Order placed successfully!')));

    context.go('/home');
  }
}
