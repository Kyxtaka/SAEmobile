import 'dart:ffi';

import 'package:sqflite/sqflite.dart';

import '../../../models/user.dart';
import '../sqlfliteDatabase.dart';

class UserTable {

  Future<void> insertUser(User user) async {
    final db = await SqlfliteDatabase.instance.database;
    await db.insert(
      'User',
      user.toMapLocal(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateUser(User user) async {
    final db = await SqlfliteDatabase.instance.database;
    await db.update(
      'User',
      user.toMapLocal(),
      where: 'email = ?',
      whereArgs: [user.mail],
    );
  }

  Future<void> deleteUser(String email) async {
    final db = await SqlfliteDatabase.instance.database;
    await db.delete(
      'User',
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  Future<List<User>> getAllUsers() async {
    final db = await SqlfliteDatabase.instance.database;
    final List<Map<String, dynamic>> usersMaps = await db.query('User');
    return usersMaps.map((map) {
      return User(
        map['mail'] as String,
        map['password'] = '',
        map['nom'] = '',
        map['prenom'] = '',
        map['role'] = '',
        map['tester'] = [],
        map['connected'] as Bool,
        map['localisation'] as String,
      );
    }).toList();
  }
}