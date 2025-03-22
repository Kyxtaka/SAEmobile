import 'dart:ffi';

import 'package:sqflite/sqflite.dart';

import '../../../models/user.dart';
import '../sqlfliteDatabase.dart';

class UserTable {
  final db;
  UserTable({required this.db});

  Future<int> insertUser(User user) async {
    return await db.insert(
      'User',
      user.toMapLocal(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateUser(User user) async {
    return await db.update(
      'User',
      user.toMapLocal(),
      where: 'email = ?',
      whereArgs: [user.mail],
    );
  }

  Future<int> deleteUser(String email) async {
    return await db.delete(
      'User',
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  Future<List<User>> getAllUsers() async {
    final List<Map<String, Object?>> usersMaps = await db.query('User');
    return usersMaps.map((map) {
      return User(
        map['mail'] as String,
        map['password'] = '',
        map['nom'] = '',
        map['prenom'] = '',
        map['role'] = '',
        map['tester'] = [],
        map['connected'] as bool,
        map['localisation'] as String,
      );
    }).toList();
  }
}