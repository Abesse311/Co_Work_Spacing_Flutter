class User {
  final String uid;
  final String name;
  final String email;
  final String role;
  final double balance;

  User({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.balance,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      // API may return 'uid' (string) or 'id'
      uid: json['uid']?.toString() ?? json['id']?.toString() ?? '',
      // API uses 'username' or 'name'
      name: json['username'] ?? json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
      // balance is a number field
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
    );
  }
}