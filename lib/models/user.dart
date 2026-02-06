class User {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final bool isLoggedIn;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.isLoggedIn,
    required this.createdAt,
  });
}
