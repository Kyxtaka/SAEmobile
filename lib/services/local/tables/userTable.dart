import 'package:sqflite/sqflite.dart';
import '../../../models/user.dart';
import '../sqlfliteDatabase.dart';


class UserTable {

/*
  static Future<void> insertUser(UserCredentials user) async {
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



  static Future<void> deleteUserCredentials() async {
    final db = await SqlfliteDatabase.instance.database;
    final UserCredentials user  = await getUserCredentials() ;
    await db.delete(
      'User',
      where: 'email = ?',
      whereArgs: [user.email],
    );
  }
*/
    Future<User?> getUserByEmail(String email) async {
      final db = await SqlfliteDatabase.instance.database;
      final List<Map<String, Object?>> result = await db.query(
        'User',
        where: 'mail = ?',
        whereArgs: [email],
      );

      if (result.isNotEmpty) {
        return User.fromMap(result.first);
      }
      return null;
  }

  /*
  Future<List<User>> getAllUsers() async {
    final db = await SqlfliteDatabase.instance.database;
    final List<Map<String, Object?>> usersMaps = await db.query('User');
    UserCredentials credentials = UserCredentials("","","");
    try {
      credentials.email = usersMaps.first['email'].toString();
      credentials.password = usersMaps.first['password'].toString();
    }catch (e) {
      print(e);
    }
    return credentials;
}
*/
