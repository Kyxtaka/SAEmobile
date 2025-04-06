import 'package:sqflite/sqflite.dart';
import 'package:saemobile/models/user.dart' as app_models;
import '../sqlfliteDatabase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserTable {

  Future<void> insertUser(app_models.User user) async {
    final db = await SqlfliteDatabase.instance.database;
    await db.insert(
      'User',
      user.toMapLocal(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateUser(app_models.User user) async {
    final db = await SqlfliteDatabase.instance.database;
    await db.update(
      'User',
      {'email': user.mail, 'password': user.password, 'localisation':'', 'id_type': 0},
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

  Future<app_models.User?> getUserByEmail(String email) async {
    final db = await SqlfliteDatabase.instance.database;
    final List<Map<String, Object?>> result = await db.query(
      'User',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return app_models.User.fromMap(result.first);
    }
    return null;
  }

  Future<List<app_models.User>> getAllUsers() async {
    final db = await SqlfliteDatabase.instance.database;
    final List<Map<String, Object?>> usersMaps = await db.query('User');

    return usersMaps.map((map) {
      return app_models.User(
        map['mail'] as String,
        map['password'] as String? ?? '',
        map['nom'] as String? ?? '',
        map['prenom'] as String? ?? '',
        map['role'] as String? ?? '',
        (map['tester'] as List<String>?) ?? [],
        (map['connected'] as int) == 1,
        map['localisation'] as String? ?? '',
      );
    }).toList();
  }
}