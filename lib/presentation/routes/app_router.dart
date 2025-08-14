import 'package:ecommerceapp/data/models/product.dart';
import 'package:ecommerceapp/presentation/pages/home_page.dart';
import 'package:ecommerceapp/presentation/pages/login_page.dart';
import 'package:ecommerceapp/presentation/pages/order_list_page.dart';
import 'package:ecommerceapp/presentation/pages/product_detail_page.dart';
import 'package:ecommerceapp/presentation/pages/splash_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (c, s) => const SplashPage()),
      GoRoute(path: '/login', builder: (c, s) => const LoginPage()),
      GoRoute(path: '/home', builder: (c, s) => const HomePage()),
       GoRoute(path: '/order', builder: (c, s) => const OrderListPage()),
      GoRoute(
        path: '/product/:id',
        builder: (c, s) {
          final extra = s.extra as ProductModel; // pass ProductModel via extra
          return ProductDetailPage(product: extra);
        },
      ),
    ],
  );
}
