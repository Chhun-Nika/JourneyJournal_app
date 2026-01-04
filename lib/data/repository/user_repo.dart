import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../dao/user_dao.dart';
import '../../model/user.dart';

class UserRepository {
  final _userDao = UserDao();

  Future<void> createUser(User user) async {
    final hashedPassword = sha256.convert(utf8.encode(user.password)).toString();
    await _userDao.insert({
      'userId': user.userId,
      'name': user.name,
      'email': user.email,
      'password': hashedPassword,
      'createdAt': user.createdAt.toIso8601String(),
      'updatedAt': user.updatedAt.toIso8601String(),
    });
  }

  Future<User?> getUserByEmail(String email) async {
    final row = await _userDao.getByEmail(email);
    if (row != null) {
      return User(
        userId: row['userId'] as String,
        name: row['name'] as String,
        email: row['email'] as String,
        password: row['password'] as String,
        createdAt: DateTime.parse(row['createdAt'] as String),
        updatedAt: DateTime.parse(row['updatedAt'] as String),
      );
    }
    return null;
  }

  Future<User?> getUserById(String userId) async {
    final row = await _userDao.getById(userId);
    if (row != null) {
      return User(
        userId: row['userId'] as String,
        name: row['name'] as String,
        email: row['email'] as String,
        password: row['password'] as String,
      );
    }
    return null;
  }

  // Future<List<User>> getAllUsers() async {
  //   final rows = await _userDao.getAll();
  //   return rows.map((row) => User(
  //     userId: row['userId'] as String,
  //     name: row['name'] as String,
  //     email: row['email'] as String,
  //   )).toList();
  // }

  Future<void> updateUser(User user) async {
    await _userDao.update(user.userId, {
      'name': user.name,
      'email': user.email,
      'updatedAt': user.updatedAt.toIso8601String(),
    });
  }

  Future<void> deleteUser(String userId) async {
    await _userDao.delete(userId);
  }

  Future<bool> login(String email, String password) async {
    // Find the user by email
    final userMap = await _userDao.getByEmail(email);
    if (userMap == null) return false;
    final userId = userMap['userId'] as String;
    return await verifyPassword(userId, password);
  }

  Future<bool> changePassword(
    String userId,
    String oldPassword,
    String newPassword,
  ) async {
    // verify the old password
    if (!await verifyPassword(userId, oldPassword)) return false;
    // hash the new password
    final newHash = sha256.convert(utf8.encode(newPassword)).toString();
    // Update in database
    await _userDao.update(userId, {
      'password': newHash,
      'updatedAt': DateTime.now().toIso8601String(),
    });

    return true;
  }

  // it is a reuseable funcution, use in changePassword and login
  // to compare the input with the exisitng hashedPassword,
  // and make sure that before comparing it, the user is existed in the dataabse
  Future<bool> verifyPassword(String userId, String password) async {
    final userMap = await _userDao.getById(userId);
    if (userMap == null) return false;

    final storedHash = userMap['password'] as String;
    final inputHash = sha256.convert(utf8.encode(password)).toString();

    return storedHash == inputHash;
  }
}
