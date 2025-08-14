import 'dart:math';

import 'package:ecommerceapp/data/models/user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel extends ChangeNotifier {
  final Map<String, UserRole> _users = {
    'user1': UserRole.user,
    'user2': UserRole.user,
    'admin': UserRole.admin,
  };

  String _generatedOtp = '';
  AppUser? _current;

  AppUser? get current => _current;
  bool get isLoggedIn => _current != null;
  bool get isAdmin => _current?.role == UserRole.admin;

  AuthViewModel() {
    _loadFromPrefs(); // load login state on init
  }

  String requestOtp(String username) {
    if (!_users.containsKey(username)) {
      throw Exception('User not found');
    }
    _generatedOtp = (1000 + Random().nextInt(9000)).toString();
    return _generatedOtp; // For demo only
  }

  Future<bool> verifyOtp(String username, String otp) async {
    if (otp == _generatedOtp && _users.containsKey(username)) {
      _current = AppUser(id: username, name: username, role: _users[username]!);
      _generatedOtp = '';
      notifyListeners();

      // Save username in shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', _current!.name);

      return true;
    }
    return false;
  }

  Future<void> setRole(UserRole role) async {
    if (_current != null) {
      _current = AppUser(
        id: _current!.id,
        name: _current!.name,
        role: role, // update dynamically
      );
      notifyListeners();

      // Persist the current role
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('role', role == UserRole.admin ? 'admin' : 'user');
    }
  }

  void restoreUser(String username) {
    if (_users.containsKey(username)) {
      _current = AppUser(id: username, name: username, role: _users[username]!);
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    _current = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username'); // remove saved username
    context.go('/login');
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final roleStr = prefs.getString('role'); // read persisted role

    if (username != null) {
      final role = roleStr == 'admin' ? UserRole.admin : UserRole.user;
      _current = AppUser(id: username, name: username, role: role);
      notifyListeners();
    }
  }
}
