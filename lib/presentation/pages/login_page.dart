import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../presentation/viewmodels/auth_viewmodel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _userCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  String? _lastOtp;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App logo with Hero animation
              Hero(
                tag: "app_logo",
                child: Icon(
                  Icons.shopping_bag_rounded,
                  size: size.width * 0.25,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                "Welcome Back!",
                style: GoogleFonts.montserrat(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Login to continue shopping",
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 40),

              // Username field
              TextField(
                controller: _userCtrl,
                decoration: InputDecoration(
                  labelText: 'User ID',
                  labelStyle: GoogleFonts.montserrat(),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // OTP field + button
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _otpCtrl,
                      decoration: InputDecoration(
                        labelText: 'Enter OTP',
                        labelStyle: GoogleFonts.montserrat(),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      try {
                        final otp = auth.requestOtp(_userCtrl.text.trim());
                        setState(() => _lastOtp = otp);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('OTP generated: $otp')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                    },
                    child: Text(
                      "Get OTP",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              if (_lastOtp != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'For demo, OTP is: $_lastOtp',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),

              const SizedBox(height: 30),

              // Login Button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final ok = await auth.verifyOtp(
                      _userCtrl.text.trim(),
                      _otpCtrl.text.trim(),
                    );

                    if (ok) {
                      // OTP verified, go to home
                      context.go('/home');
                    } else {
                      // Invalid OTP
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invalid OTP')),
                      );
                    }
                  },

                  child: Text(
                    "Login",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Footer
              Text(
                "Log in as user1, user2, or admin",
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
