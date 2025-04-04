

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

  static Future<UserCredentials> getUserCredentials() async {
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
  */
}