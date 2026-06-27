class User {
  final String  uid;
  final String? firebaseUid;
  final String  name;
  final String  email;
  final String? phone;
  final String  role;
  final double  balance;
  final String  authProvider;
  final bool    isVerified;

  User({
    required this.uid,
    this.firebaseUid,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    required this.balance,
    required this.authProvider,
    required this.isVerified,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid:          json['uid']?.toString() ?? json['id']?.toString() ?? '',
      firebaseUid:  json['firebase_uid']?.toString(),
      name:         json['username'] ?? json['name'] ?? '',
      email:        json['email'] ?? '',
      phone:        json['phone']?.toString() ?? json['number']?.toString(),
      role:         json['role'] ?? 'user',
      balance:      (json['balance'] as num?)?.toDouble() ?? 0.0,
      authProvider: json['auth_provider'] ?? 'local',
      isVerified:   json['is_verified'] == true,
    );
  }
}