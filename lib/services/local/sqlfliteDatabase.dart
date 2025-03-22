import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlfliteDatabase {
  static final SqlfliteDatabase instance = SqlfliteDatabase._init();
  static Database? _database;
  SqlfliteDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'bd.db'),
      onCreate: (db, version) {
        _createRestaurants(db);
        _createTypeCuisine(db);
        _createUser(db);
        _createCritique(db);
      },
      version: 1,
    );
  }

  Future _createRestaurants(Database db) {
    return db.execute(
        '''
    CREATE TABLE restaurants(
      id INTEGER PRIMARY KEY,
      name TEXT,
      address TEXT
    )
    '''
    );
  }

  Future _createTypeCuisine(Database db) {
    return db.execute(
        '''
    CREATE TABLE TypeCuisine(
    )
    '''
    );
  }

  Future _createUser(Database db) {
    return db.execute(
        '''
    CREATE TABLE TypeCuisine(
    )
    '''
    );
  }

  Future _createCritique(Database db) {
    return db.execute(
        '''
    CREATE TABLE TypeCuisine(
    )
    '''
    );
  }
}
