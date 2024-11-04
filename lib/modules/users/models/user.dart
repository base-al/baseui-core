import 'package:flutter/material.dart';

class User {
  final int id;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  final String? name;
  final String? email;
  final String? username;
  final String? avatar;

  User({
    required this.id,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    this.name,
    this.email,
    this.username,
    this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      // Helper function to get field value checking both cases
      T? getField<T>(String fieldName) {
        return json[fieldName] as T? ?? json[fieldName.toLowerCase()] as T?;
      }

      // Helper function for DateTime fields
      DateTime? parseDateTime(String fieldName) {
        final value = json[fieldName] ?? json[fieldName.toLowerCase()];
        if (value == null || value == '0001-01-01T00:00:00Z') {
          return null;
        }
        return DateTime.parse(value as String);
      }

      return User(
        id: getField<int>('ID') ?? getField<int>('id') ?? 0,
        deletedAt: parseDateTime('DeletedAt') ?? parseDateTime('deleted_at'),
        createdAt: parseDateTime('CreatedAt') ??
            parseDateTime('created_at') ??
            DateTime.now(),
        updatedAt: parseDateTime('UpdatedAt') ??
            parseDateTime('updated_at') ??
            DateTime.now(),
        name: getField<String>('name') ?? '',
        email: getField<String>('email') ?? '',
        username: getField<String>('username') ?? '',
        avatar: getField<String>('avatar') ?? '',
      );
    } catch (e, stackTrace) {
      debugPrint('Error creating User from JSON: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'name': name,
      'email': email,
      'username': username,
      'avatar': avatar,
    };
  }

  User copyWith({
    int? id,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? name,
    String? email,
    String? username,
    String? avatar,
  }) {
    return User(
      id: id ?? this.id,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      name: name ?? this.name,
      email: email ?? this.email,
      username: username ?? this.username,
      avatar: avatar ?? this.avatar,
    );
  }

  factory User.empty() {
    return User(
      id: 0,
      deletedAt: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      name: '',
      email: '',
      username: '',
      avatar: '',
    );
  }

  factory User.create({
    String? name,
    String? email,
    String? username,
    String? avatar,
  }) {
    return User(
      id: 0,
      deletedAt: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      name: name ?? '',
      email: email ?? '',
      username: username ?? '',
      avatar: avatar ?? '',
    );
  }

  bool get isDeleted => deletedAt != null;
}
