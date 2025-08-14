enum UserRole { user, admin }

class AppUser {
  final String id;
  final String name;
  final UserRole role;
  AppUser({required this.id, required this.name, required this.role});
}
