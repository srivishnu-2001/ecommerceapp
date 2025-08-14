import 'package:ecommerceapp/presentation/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');

    final auth = context.read<AuthViewModel>();

    if (username != null && username.isNotEmpty) {
      // Restore current user in AuthViewModel
      auth.restoreUser(username);
      context.go('/home'); // Navigate to home
    } else {
      context.go('/login'); // Navigate to login
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: FlutterLogo(size: 96)));
  }
}
