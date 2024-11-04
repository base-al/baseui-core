// lib/core/modules/user/models/user_profile.dart
class User {
  final int id;
  final String username;
  final String email;
  final String name;
  final String? avatar;
  final String? stripeId;
  final DateTime? lastLogin;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.name,
    this.avatar,
    this.stripeId,
    this.lastLogin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String?,
      stripeId: json['stripe_id'] as String?,
      lastLogin: json['last_login'] != null
          ? DateTime.parse(json['last_login'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'name': name,
        'avatar': avatar,
        'stripe_id': stripeId,
        'last_login': lastLogin?.toIso8601String(),
      };

  // Add a copyWith method for updating user data
  User copyWith({
    int? id,
    String? username,
    String? email,
    String? name,
    String? avatar,
    String? stripeId,
    DateTime? lastLogin,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      stripeId: stripeId ?? this.stripeId,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }
}
