// lib/core/modules/auth/models/auth_data.dart
class AuthData {
  final String accessToken;
  final int exp;

  AuthData({
    required this.accessToken,
    required this.exp,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      accessToken: json['accessToken'] as String,
      exp: json['exp'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'exp': exp,
      };

  bool get isTokenExpired {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return now >= exp;
  }
}
