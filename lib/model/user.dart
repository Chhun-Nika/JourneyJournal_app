import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class User {
  final String userId;
  final String name;
  final String email;
  // this stored as hash not raw
  final String password; 
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    String? userId,
    required this.name,
    required this.email,
    required this.password,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : userId = userId ?? uuid.v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  User copyWith({String? name, String? email, String? password}) {
    return User(
      userId: userId,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      createdAt: createdAt,
      updatedAt: DateTime.now()
    );
  }

  bool verifyPassword(String input) {
    final inputHash = sha256.convert(utf8.encode(input)).toString();
    return password == inputHash;
  }

}
