import 'package:ecommerceapp/core/app_theme.dart';
import 'package:ecommerceapp/presentation/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EcomApp extends StatelessWidget {
  const EcomApp({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.buildTheme();
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'MVVM Shop',
      theme: theme.copyWith(
        textTheme: GoogleFonts.montserratTextTheme(theme.textTheme),
      ),
      routerConfig: AppRouter.router,
    );
  }
}
