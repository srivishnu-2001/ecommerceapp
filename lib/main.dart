import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'app.dart';
import 'data/repositories/product_repository.dart'; // contains both ProductRepository & ProductApiService
import 'presentation/viewmodels/admin_viewmodel.dart';
import 'presentation/viewmodels/auth_viewmodel.dart';
import 'presentation/viewmodels/cart_viewmodel.dart';
import 'presentation/viewmodels/product_detail_viewmodel.dart';
import 'presentation/viewmodels/product_list_viewmodel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Create API service and repository
  final productApiService = ProductApiService(http.Client());
  final productRepository = ProductRepository(productApiService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(
          create: (_) => ProductListViewModel(productRepository),
        ),
        ChangeNotifierProvider(create: (_) => ProductDetailViewModel()),
        ChangeNotifierProvider(create: (_) => CartViewModel()),
        ChangeNotifierProvider(
          create: (_) => AdminViewModel(productRepository),
        ),
      ],
      child: const EcomApp(),
    ),
  );
}
