import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerceapp/data/models/product.dart';
import 'package:ecommerceapp/presentation/viewmodels/cart_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key});

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final ordersJson = prefs.getStringList('orders') ?? [];
    setState(() {
      orders =
          ordersJson
              .map((order) => jsonDecode(order) as Map<String, dynamic>)
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartViewModel>(); 

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text('My Orders'), centerTitle: true),
      body:
          orders.isEmpty
              ? const Center(
                child: Text(
                  'No orders found',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  final date = order['date'] ?? '';

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Order Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Order #${index + 1}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '₹${order['total']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Date: $date',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                          const Divider(height: 20),

                          // Order Items with images from CartViewModel products
                          Column(
                            children:
                                (order['items'] as List).map((item) {
                                  final title = item['title'];
                                  final qty = item['qty'];
                                  final price = item['price'];
                                  final image = item['image'] ;

                                  // Find product from cart's known products for image
                                  ProductModel? productWithImage;
                                  try {
                                    productWithImage = cart.items
                                        .map((c) => c.product)
                                        .firstWhere((p) => p.title == title);
                                  } catch (_) {}

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child:
                                              productWithImage != null
                                                  ? CachedNetworkImage(
                                                    imageUrl:
                                                        image,
                                                    height: 60,
                                                    width: 60,
                                                    fit: BoxFit.cover,
                                                  )
                                                  : Container(
                                                    height: 60,
                                                    width: 60,
                                                    color: Colors.grey[300],
                                                    child: const Icon(
                                                      Icons.image,
                                                    ),
                                                  ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                title,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '₹$price x $qty',
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          '₹${price * qty}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                          ),
                          const Divider(height: 20),

                          // User Info
                          Text(
                            '${order['name']} | ${order['phone']}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            order['address'],
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
